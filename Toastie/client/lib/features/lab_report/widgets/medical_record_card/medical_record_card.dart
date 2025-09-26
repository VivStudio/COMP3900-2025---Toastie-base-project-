import 'package:flutter/material.dart';
import 'package:toastie/clients/lab_report_upload_client.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/shared/widgets/image/fetch_image.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/utils.dart';

class MedicalRecordCard extends StatelessWidget {
  MedicalRecordCard({required this.medicalRecord});

  final LabReportEntity medicalRecord;
  final MaterialColor color = info;

  Widget Photo() {
    if (medicalRecord.photo_ids == null || medicalRecord.photo_ids!.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: gridbaseline * 2),
          child: FetchImage(
            fetchCall: locator<LabReportUploadClient>()
                .getPhoto(medicalRecord.photo_ids!.first),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget DefaultCardContents({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeFirstCharacter(medicalRecord.name.toString()),
          style: titleMediumTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
        Visibility(
          visible: medicalRecord.referred_by != null &&
              medicalRecord.referred_by!.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: gridbaseline / 2),
              Text(
                'Referred by: ${medicalRecord.referred_by}',
                style: labelMediumTextWithColor(
                  context,
                  color[700] as Color,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: medicalRecord.examined_by != null &&
              medicalRecord.examined_by!.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: gridbaseline / 2),
              Text(
                'Examined by: ${medicalRecord.examined_by}',
                style: labelMediumTextWithColor(
                  context,
                  color[700] as Color,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: (medicalRecord.photo_ids != null &&
                  medicalRecord.photo_ids!.isNotEmpty) ||
              (medicalRecord.summary != null &&
                  medicalRecord.summary!.length > 0),
          child: SizedBox(height: gridbaseline),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Photo(),
            Visibility(
              visible: medicalRecord.summary != null &&
                  medicalRecord.summary!.length > 0,
              child: Expanded(
                child: Text(
                  medicalRecord.summary.toString(),
                  style: bodySmallTextWithColor(
                    context: context,
                    color: color[900] as Color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget StackedCardContents({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeFirstCharacter(medicalRecord.name.toString()),
          style: titleMediumTextWithColor(
            context: context,
            color: color[900] as Color,
          ),
        ),
        Visibility(
          visible: medicalRecord.referred_by != null &&
              medicalRecord.referred_by!.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: gridbaseline / 2),
              Text(
                'Referred by: ${medicalRecord.referred_by}',
                style: labelMediumTextWithColor(
                  context,
                  color[700] as Color,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: medicalRecord.examined_by != null &&
              medicalRecord.examined_by!.isNotEmpty,
          child: Column(
            children: [
              SizedBox(height: gridbaseline / 2),
              Text(
                'Examined by: ${medicalRecord.examined_by}',
                style: labelMediumTextWithColor(
                  context,
                  color[700] as Color,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: medicalRecord.summary != null &&
              medicalRecord.summary!.length > 0,
          child: Column(
            children: [
              SizedBox(height: gridbaseline),
              Text(
                medicalRecord.summary.toString(),
                style: labelMediumTextWithColor(
                  context,
                  color[900] as Color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ],
          ),
        ),
        Photo(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClickableSummaryCard(
      solidColor: color[100],
      defaultCardContents: DefaultCardContents(context: context),
      stackedCardContents: StackedCardContents(context: context),
      actionHandler: () => {},
    );
  }
}
