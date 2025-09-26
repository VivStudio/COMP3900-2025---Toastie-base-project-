import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/symptom/symptom_logs_entity.dart';
import 'package:toastie/features/symptom/utils/symptom_severity.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/layout/grid.dart';
import 'package:toastie/utils/time/time_details.dart';
import 'package:toastie/utils/utils.dart';

class SymptomCard extends StatelessWidget {
  SymptomCard({
    required this.symptom,
  })  : color = _getCardColor(symptom: symptom),
        severity = _getSeverity(symptom: symptom);

  final SymptomLogsEntity symptom;
  final MaterialColor color;
  final SymptomSeverity severity;

  static SymptomSeverity _getSeverity({required SymptomLogsEntity symptom}) {
    return symptom.severity ?? SymptomSeverity.moderate;
  }

  static MaterialColor _getCardColor({required SymptomLogsEntity symptom}) {
    SymptomSeverity severity = _getSeverity(symptom: symptom);
    return symptomSeverityMap[severity.index]!.trackColor;
  }

  Widget StackedCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capitalizeFirstCharacter(
            capitalizeFirstCharacter(symptom.details!.name.toString()),
          ),
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
        Text(
          symptomSeverityMap[severity.index]!.name,
          style: labelMediumTextWithColor(context, color[600]!),
        ),
      ],
    );
  }

  Widget DefaultCardContents({
    required BuildContext context,
    required String time,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                capitalizeFirstCharacter(symptom.details!.name.toString()),
                style: titleMediumTextWithColor(
                  context: context,
                  color: color[900]!,
                ),
              ),
            ),
            SizedBox(width: gridbaseline),
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
          symptomSeverityMap[severity.index]!.name,
          style: labelMediumTextWithColor(context, color[600]!),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TimeDetails timeDetails = timeDetailsFromUnixDateTime(symptom.date_time!);
    bool isAM = timeDetails.isAm;
    List<bool> selectedTimeSuffix = [isAM, !isAM];

    final String time = stringFromTimeDetails(
      details: timeDetails,
      selectedTimeSuffix: selectedTimeSuffix,
    );

    return ClickableSummaryCard(
      solidColor: color[100],
      defaultCardContents: DefaultCardContents(context: context, time: time),
      stackedCardContents: StackedCardContents(context: context, time: time),
      actionHandler: () => {},
    );
  }
}
