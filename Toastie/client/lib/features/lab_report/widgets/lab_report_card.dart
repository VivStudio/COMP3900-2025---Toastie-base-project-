import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:toastie/clients/lab_report_upload_client.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/themes/text/text_utils.dart';
import 'package:toastie/utils/layout/border_radius.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:toastie/features/lab_report/utils/report_card_utils.dart';
import 'package:toastie/utils/utils.dart';

class LabReportCard extends StatelessWidget {
  LabReportCard({
    required this.labReport,
    required this.actionHandler,
  });

  final VoidCallback actionHandler;
  final LabReportEntity labReport;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      solidColor: Colors.white,
      child: Padding(
        padding: cardLargeInnerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labReport.photo_ids?.isNotEmpty ?? false)
                  Padding(
                    padding: EdgeInsets.only(right: gridbaseline * 2),
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: FutureBuilder<Uint8List?>(
                        future: locator<LabReportUploadClient>()
                            .getPhoto(labReport.photo_ids!.first),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: gridbaseline * 12,
                              height: gridbaseline * 12,
                              color: primary[100],
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primary[400],
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return Container(
                              width: gridbaseline * 12,
                              height: gridbaseline * 12,
                              color: primary[100],
                              child: Icon(
                                Icons.image_not_supported,
                                color: primary[400],
                                size: gridbaseline * 4,
                              ),
                            );
                          }

                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            width: gridbaseline * 12,
                            height: gridbaseline * 12,
                          );
                        },
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeFirstCharacter(
                          labReport.name ?? 'Untitled Report',
                        ),
                        style: titleSmallTextWithColor(
                          context: context,
                          color: primary[900] as Color,
                          fontFamily: ToastieFontFamily.libreBaskerville,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: gridbaseline / 2),
                      Text(
                        formatDate(labReport.date_time),
                        style: titleSmallTextWithColor(
                          context: context,
                          color: primary[700] as Color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (labReport.referred_by != null &&
                          labReport.referred_by!.length > 0) ...[
                        SizedBox(height: gridbaseline / 2),
                        Text(
                          'Referred by: ${labReport.referred_by}',
                          style: labelSmallTextWithColor(
                            context,
                            primary[700] as Color,
                          ).copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                      if (labReport.examined_by != null &&
                          labReport.examined_by!.length > 0) ...[
                        SizedBox(height: gridbaseline / 2),
                        Text(
                          'Examined by: ${labReport.examined_by}',
                          style: labelSmallTextWithColor(
                            context,
                            primary[700] as Color,
                          ).copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: gridbaseline),
                Icon(
                  Icons.arrow_forward_ios,
                  color: primary,
                  size: extraSmallIconSize,
                ),
              ],
            ),
            if (labReport.summary?.isNotEmpty != null) ...[
              SizedBox(height: gridbaseline),
              Text(
                labReport.summary!,
                style: bodySmallTextWithColor(
                  context: context,
                  color: neutral[900] as Color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
      actionHandler: actionHandler,
    );
  }
}
