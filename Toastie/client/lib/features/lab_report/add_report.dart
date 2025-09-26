import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/drop_down_menu.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/components/time_editor/date_time_editor.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/features/image/removeable_image.dart';
import 'package:toastie/features/lab_report/screens/report_card_screen.dart';
import 'package:toastie/services/lab_report_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:toastie/utils/utils.dart';

class AddReport extends StatefulWidget {
  AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController referredByController = TextEditingController();
  final TextEditingController examinedByController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isSaveEnabled = false;

  DateTime date = DateTime.now();
  String _selectedType = capitalizeFirstCharacter(ReportType.lab.name);
  bool showDateEditor = false;
  bool _isSaving = false;
  final List<File> _imagesToUpload = [];
  final List<Future<GenerateContentResponse>> _processingFutures = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Listen for changes in the name field to update save button state
    nameController.addListener(_updateSaveEnabled);
    // Also check initial state
    _updateSaveEnabled();
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
      // Deduplicate images
      if (!_imagesToUpload.any((f) => f.path == selectedImage.path)) {
        _imagesToUpload.add(selectedImage);
      }
    });
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

  void _updateSaveEnabled() {
    final bool enabled = nameController.text.trim().isNotEmpty;
    if (enabled != isSaveEnabled) {
      setState(() {
        isSaveEnabled = enabled;
      });
    }
  }

  Future _handleAddReport() async {
    setState(() {
      _isSaving = true;
    });

    LabReportEntity? entity = await locator<LabReportService>().addLabReport(
      dateTime: date,
      files: _imagesToUpload,
      name: nameController.text,
      type: _selectedType,
      examinedBy: examinedByController.text,
      referredBy: referredByController.text,
      notes: notesController.text,
    );

    Navigator.of(context).pop(true);

    if (entity != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportCardScreen(
            entity: entity,
            processingResults: _processingFutures,
          ),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToastieTextFieldWithController(
              controller: nameController,
              color: primary,
              hintText: 'Add report name',
              floatingLabel: 'Report name',
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
            DateTimeEditor(
              dateTime: date,
              pickerMode: CupertinoDatePickerMode.date,
              showEditor: showDateEditor,
              onDateTimeChange: editDate,
              onDateTimeChanged: saveDate,
              color: primary,
            ),
            SizedBox(height: gridbaseline),
            DropDownMenu(
              color: primary,
              selected: _selectedType,
              options: ReportType.values
                  .map((e) => capitalizeFirstCharacter(e.name))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
            ),
            SizedBox(height: gridbaseline),
            ToastieTextFieldWithController(
              controller: notesController,
              color: primary,
              hintText: 'Add notes',
              floatingLabel: 'Notes (optional)',
            ),
          ],
        ),
        Wrap(
          direction: Axis.horizontal,
          children: [
            UploadPhotoButton(
              IconType.PhotoCamera,
              _addImageFromCamera,
            ),
            UploadPhotoButton(
              IconType.PhotoGallery,
              _addImagesFromGallery,
            ),
            // TODO: refactor to consolidate with magic tracker photo picker
            // PhotoPicker(
            //   type: ImageSource.camera,
            //   iconColor: primary,
            //   addPhotoToUpload: _addImageFromCamera,
            //   context: context,
            // ),
            // PhotoPicker(
            //   type: ImageSource.gallery,
            //   iconColor: primary,
            //   addPhotoToUpload: addPhotoToUpload,
            //   enableImageMultiSelectInGallery: false,
            //   context: context,
            // ),
          ],
        ),
        if (_imagesToUpload.isNotEmpty)
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount:
                isTabletFromSize(size: MediaQuery.of(context).size) ? 4 : 3,
            crossAxisSpacing: gridbaseline,
            mainAxisSpacing: gridbaseline,
            children: _imagesToUpload.map((file) {
              return RemoveableImage(
                image: file,
                deleteButtonColor: accentPink,
                removeImage: () {
                  setState(() {
                    _imagesToUpload.remove(file);
                  });
                },
              );
            }).toList(),
          ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: gridbaseline * 2),
            child: _isSaving
                ? Button(
                    buttonType: ButtonType.SavingButton,
                    text: 'Saving...',
                    color: neutral,
                    actionHandler: () => {},
                    fullWidth: false,
                  )
                : GradientButton(
                    actionHandler: () async {
                      isSaveEnabled ? await _handleAddReport() : () {};
                    },
                    gradient: gradientButtonMain,
                    text: 'Save',
                    withTopPadding: false,
                  ),
          ),
        ),
      ],
    );
  }
}
