import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/features/period/utils/period_flow.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/utils.dart';

class PeriodCard extends StatelessWidget {
  PeriodCard({required this.period})
      : color = periodFlowMap[period.severity?.index]!.trackColor;

  final PeriodLogsEntity period;
  final MaterialColor color;

  Widget Content({required BuildContext context}) {
    return Row(
      children: [
        Image(
          image: AssetImage(
            periodFlowMap[period.severity?.index]!.iconPath.toString(),
          ),
          width: gridbaseline * 4,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(width: gridbaseline / 2),
        Expanded(
          child: Text(
            capitalizeFirstCharacter(
              '${periodFlowMap[period.severity?.index]!.name} flow',
            ),
            style: titleMediumTextWithColor(
              context: context,
              color: color[900]!,
            ),
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
