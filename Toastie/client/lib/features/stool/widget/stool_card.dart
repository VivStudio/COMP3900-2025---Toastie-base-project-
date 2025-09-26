import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/features/stool/utils/stool_severity.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/time/time_details.dart';

class StoolCard extends StatelessWidget {
  StoolCard({required this.stool})
      : color = stoolSeverityMap[stool.severity?.index]!.trackColor;

  final StoolLogsEntity stool;
  final MaterialColor color;

  Widget Content({required BuildContext context}) {
    TimeDetails timeDetails = timeDetailsFromUnixDateTime(stool.date_time!);
    bool isAM = timeDetails.isAm;
    List<bool> selectedTimeSuffix = [isAM, !isAM];

    final String time = stringFromTimeDetails(
      details: timeDetails,
      selectedTimeSuffix: selectedTimeSuffix,
    );

    return Row(
      children: [
        Image(
          image: AssetImage(
            stoolSeverityMap[stool.severity?.index]!.iconPath.toString(),
          ),
          width: gridbaseline * 4,
          height: gridbaseline * 5,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(width: gridbaseline / 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    stoolSeverityMap[stool.severity?.index]!.name,
                    style: titleMediumTextWithColor(
                      context: context,
                      color: color[900]!,
                    ),
                  ),
                  Text(
                    time,
                    style: bodyMediumTextWithColor(
                      context: context,
                      color: color[900] as Color,
                    ),
                  ),
                ],
              ),
              Text(
                stoolSeverityMap[stool.severity?.index]!.description,
                style: labelMediumTextWithColor(context, color[600]!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClickableSummaryCard(
      solidColor: color[100],
      defaultCardContents: Content(context: context),
      stackedCardContents: Content(context: context),
      actionHandler: () => {},
    );
  }
}
