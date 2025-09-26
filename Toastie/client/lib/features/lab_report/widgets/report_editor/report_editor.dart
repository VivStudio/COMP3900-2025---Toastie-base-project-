import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/drop_down_menu.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/components/time_editor/date_time_editor.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/features/image/removeable_image.dart';
import 'package:toastie/features/lab_report/utils/report_card_utils.dart';
import 'package:toastie/features/lab_report/widgets/report_editor/image_carousel.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text_utils.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:toastie/utils/time/time_utils.dart';
import 'package:toastie/utils/utils.dart';
import 'package:toastie/clients/lab_report_upload_client.dart';

class ReportEditor extends StatefulWidget {
  ReportEditor({
    required this.entity,
    required this.isEditState,
    required this.saveMethods,
    this.processingResults = const [],
  });

  final LabReportEntity entity;
  final List<Future<GenerateContentResponse>> processingResults;
  final bool isEditState;
  final List<Function> saveMethods;

  @override
  State<ReportEditor> createState() => _ReportEditorState();
}

class _ReportEditorState extends State<ReportEditor> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referredByController = TextEditingController();
  final TextEditingController examinedByController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  List<String> imageIds = [];
  final List<Uint8List> imageData = [];
  final List<File> imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  final List<File> _imagesToUpload = [];
  final List<File> _imagesToDelete = [];

  bool isLoadingSummary = false;
  bool isLoadingImages = false;
  bool showDateEditor = false;
  late DateTime date;
  late String _selectedType;
  late LabReportEntity _originalEntity;
  late LabReportEntity _updatedDetails;
  List<String> reportTypes =
      ReportType.values.map((e) => capitalizeFirstCharacter(e.name)).toList();

  @override
  void initState() {
    super.initState();
    _originalEntity = widget.entity;
    renderCard();
    if (widget.processingResults.isNotEmpty) {
      isLoadingSummary = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages();
    _getSummary();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    referredByController.dispose();
    examinedByController.dispose();
    noteController.dispose();
    summaryController.dispose();

    widget.saveMethods.remove(updateEntry);
    super.dispose();
  }

  Future _getSummary() async {
    if (widget.processingResults.isEmpty) {
      return;
    }

    List<GenerateContentResponse> summaries =
        await Future.wait(widget.processingResults);

    List<String> summaryStrings =
        summaries.map((summary) => summary.text ?? '').toList();
    String summary = summaryStrings.join('. ');
    updateSummary(summary);
  }

  Future<void> _loadImages() async {
    if (imageIds.isEmpty) return;

    setState(() {
      isLoadingImages = true;
    });

    for (String imageId in imageIds) {
      Uint8List? imageBytes =
          await locator<LabReportUploadClient>().getPhoto(imageId);
      if (imageBytes != null) {
        imageData.add(imageBytes);

        // Write Uint8 image to File
        String tempPath = (await getTemporaryDirectory()).path;
        File _imageFile = File('$tempPath/$imageId');
        await _imageFile.writeAsBytes(
          imageBytes.buffer
              .asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes),
        );
        imageFiles.add(_imageFile);
      }
    }

    setState(() {
      isLoadingImages = false;
    });
  }

  void renderCard() {
    nameController.text =
        capitalizeFirstCharacter(widget.entity.name ?? 'Unnamed report');
    dateController.text = formatDate(widget.entity.date_time);
    date = convertUnixToDateTime(widget.entity.date_time!);
    referredByController.text = widget.entity.referred_by ?? '';
    examinedByController.text = widget.entity.examined_by ?? '';
    imageIds = widget.entity.photo_ids ?? [];
    noteController.text = widget.entity.notes ?? '';
    summaryController.text = widget.entity.summary ?? '';

    widget.saveMethods.add(updateEntry);
  }

  void updateEntity() {
    setState(() {
      _originalEntity.update(
        name: _updatedDetails.name,
        date_time: _updatedDetails.date_time,
        referred_by: _updatedDetails.referred_by,
        examined_by: _updatedDetails.examined_by,
        type: _updatedDetails.type,
        notes: _updatedDetails.notes,
        summary: _updatedDetails.summary,
        photo_ids: _updatedDetails.photo_ids,
      );
      formatDate(_updatedDetails.date_time);
    });
  }

  Future<LabReportEntity> getUpdatedDetails() async {
    String name = nameController.text;
    String referredBy = referredByController.text;
    String examinedBy = examinedByController.text;
    String notes = noteController.text;
    String summary = summaryController.text;
    ReportType? type;
    if (_selectedType.isNotEmpty) {
      int reportTypeIndex = reportTypes.indexOf(
        _selectedType,
      );
      type = ReportType.values[reportTypeIndex];
    } else {
      type = _originalEntity.type!;
    }

    final photoIds = List<String>.from(imageIds);
    // Upload new images
    for (File img in _imagesToUpload) {
      String? uuid = await locator<LabReportService>().addPhoto(file: img);
      photoIds.add(uuid);
    }

    // Delete removed images
    for (File img in _imagesToDelete) {
      String imgId = getFileId(img);
      await locator<LabReportService>().deletePhoto(photo_id: imgId);
      photoIds.remove(imgId);
    }

    return LabReportEntity(
      name: name,
      date_time: convertToUnixDateTime(date),
      referred_by: referredBy,
      examined_by: examinedBy,
      notes: notes,
      summary: summary,
      type: type,
      photo_ids: photoIds,
    );
  }

  String getFileId(File file) {
    return file.path.split('/').last;
  }

  Future updateEntry() async {
    _updatedDetails = await getUpdatedDetails();

    await locator<LabReportService>().updateLabReport(
      id: _originalEntity.id!,
      entity: _updatedDetails,
    );

    updateEntity();
  }

  void editDate() {
    setState(() {
      showDateEditor = !showDateEditor;
    });
  }

  void saveDate(DateTime dateTime) {
    setState(() {
      date = dateTime;
    });
  }

  void _deleteReport(BuildContext context) async {
    await locator<LabReportService>().deleteLabReportWithId(
      id: _originalEntity.id!,
    );

    Navigator.of(context).pop(true);
  }

  Future updateSummary(String summary) async {
    summary = stripTrailingNewlines(summary);
    summary += '\n\nToastie can make mistakes. Please check important info!';

    // Update the lab report with the new summary
    LabReportEntity updatedEntity = _originalEntity;
    updatedEntity.update(summary: summary);

    await locator<LabReportService>().updateLabReport(
      id: _originalEntity.id!,
      entity: updatedEntity,
    );

    setState(() {
      isLoadingSummary = false;
      summaryController.text = summary;
    });
  }

  Future _refreshSummary() async {
    setState(() {
      isLoadingSummary = true;
    });

    updateSummary('');
  }

  Widget Report() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                nameController.text,
                style: titleMediumTextWithColor(
                  context: context,
                  color: primary[900]!,
                  fontFamily: ToastieFontFamily.libreBaskerville,
                ),
              ),
            ),
            Text(
              formatDate(convertToUnixDateTime(date)),
              style: bodySmallTextWithColor(
                context: context,
                color: primary[900] as Color,
              ),
            ),
          ],
        ),
        SizedBox(height: gridbaseline),
        Visibility(
          visible: referredByController.text.isNotEmpty,
          child: Text(
            'Referred by: ${referredByController.text}',
            style: bodySmallTextWithColor(
              context: context,
              color: primary[600] as Color,
            ),
          ),
        ),
        Visibility(
          visible: examinedByController.text.isNotEmpty,
          child: Text(
            'Examined by: ${examinedByController.text}',
            style: bodySmallTextWithColor(
              context: context,
              color: primary[600] as Color,
            ),
          ),
        ),
        SizedBox(height: gridbaseline * 2),
        if (isLoadingImages)
          Center(child: CircularProgressIndicator())
        else
          ImageCarousel(imageFiles: imageFiles),
        SizedBox(height: gridbaseline * 2),
        if (noteController.text.isNotEmpty)
          Text(
            'Notes',
            style: titleSmallTextWithColor(
              context: context,
              color: primary[900]!,
              fontFamily: ToastieFontFamily.libreBaskerville,
            ),
          ),
        if (noteController.text.isNotEmpty) Text(noteController.text),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: primary[900],
                ),
                SizedBox(width: gridbaseline),
                Text(
                  'Summary',
                  style: titleSmallTextWithColor(
                    context: context,
                    color: primary[900]!,
                    fontFamily: ToastieFontFamily.libreBaskerville,
                  ),
                ),
              ],
            ),
            ToastieIconButton(
              iconType: IconType.Refresh,
              iconColor: primary[900]!,
              actionHandler: _refreshSummary,
            ),
          ],
        ),
        if (isLoadingSummary)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: gridbaseline * 2,
                  color: Colors.white,
                ),
                SizedBox(height: gridbaseline),
                Container(
                  width: double.infinity,
                  height: gridbaseline * 2,
                  color: Colors.white,
                ),
                SizedBox(height: gridbaseline),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: gridbaseline * 2,
                  color: Colors.white,
                ),
              ],
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(bottom: gridbaseline * 4),
            child: Text(summaryController.text),
          ),
      ],
    );
  }

  Widget EditableImages() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount:
          isTabletFromSize(size: MediaQuery.of(context).size) ? 4 : 3,
      crossAxisSpacing: gridbaseline,
      mainAxisSpacing: gridbaseline,
      children: imageFiles.map((file) {
        return RemoveableImage(
          image: file,
          deleteButtonColor: accentPink,
          removeImage: () {
            setState(() {
              imageFiles.remove(file);
              _imagesToDelete.add(file);
            });
          },
        );
      }).toList(),
    );
  }

  // TODO: consolidate with import 'package:toastie/utils/layout/grid.dart'
  double imageGridItemSize(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return isTabletFromSize(size: size) ? gridbaseline * 18 : gridbaseline * 10;
  }

  Widget UploadPhotoButton(IconType iconType, actionHandler) {
    final double dimension = imageGridItemSize(context);
    return Padding(
      padding: const EdgeInsets.only(
        right: gridbaseline,
        top: gridbaseline,
        bottom: gridbaseline,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(gridbaseline),
        child: Container(
          height: dimension,
          width: dimension,
          color: primary[100],
          child: ToastieIconButton(
            iconType: iconType,
            iconColor: primary,
            iconButtonType: IconButtonType.DefaultButton,
            actionHandler: actionHandler,
          ),
        ),
      ),
    );
  }

  void _addImagesFromGallery() async {
    List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.length > 0) {
      pickedFiles.forEach((file) {
        File image = File(file.path);
        addPhotoToUpload(image);
      });
    }
  }

  void _addImageFromCamera() async {
    XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      addPhotoToUpload(selectedImage);
    }
  }

  void addPhotoToUpload(File selectedImage) {
    setState(() {
      imageFiles.add(selectedImage);
      _imagesToUpload.add(selectedImage);
    });
  }

  Widget ReportEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToastieTextFieldWithController(
          controller: nameController,
          color: primary,
          floatingLabel: 'Name',
          hintText: 'Report name',
          minLines: textMinLines,
          maxLines: null,
        ),
        DateTimeEditor(
          dateTime: date,
          pickerMode: CupertinoDatePickerMode.date,
          showEditor: showDateEditor,
          onDateTimeChange: editDate,
          onDateTimeChanged: saveDate,
          color: primary,
        ),
        ToastieTextFieldWithController(
          controller: referredByController,
          color: primary,
          hintText: 'Dr. General Practitioner',
          floatingLabel: 'Referred by (optional)',
        ),
        ToastieTextFieldWithController(
          controller: examinedByController,
          color: primary,
          hintText: 'Dr. Phy Sician',
          floatingLabel: 'Examined by (optional)',
        ),
        SizedBox(height: gridbaseline),
        DropDownMenu(
          color: primary,
          selected:
              capitalizeFirstCharacter(widget.entity.type!.name.toString()),
          options: reportTypes,
          onChanged: (newValue) {
            setState(() {
              _selectedType = newValue!;
            });
          },
        ),
        SizedBox(height: gridbaseline),
        Wrap(
          children: [
            UploadPhotoButton(
              IconType.PhotoCamera,
              _addImageFromCamera,
            ),
            UploadPhotoButton(
              IconType.PhotoGallery,
              _addImagesFromGallery,
            ),
          ],
        ),
        EditableImages(),
        SizedBox(height: gridbaseline * 2),
        ToastieTextFieldWithController(
          controller: noteController,
          color: primary,
          hintText: 'Add notes',
          floatingLabel: 'Notes (optional)',
        ),
        Button(
          buttonType: ButtonType.TextButton,
          text: 'Delete report',
          color: critical,
          actionHandler: () => _deleteReport(context),
          icon: Icons.delete_outline,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEditState ? ReportEditor() : Report();
  }
}
