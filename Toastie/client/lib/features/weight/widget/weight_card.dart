import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_summary_card.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';

class WeightCard extends StatelessWidget {
  WeightCard({required this.weight});

  final WeightLogsEntity weight;
  final MaterialColor color = accentYellow;

  Widget Content({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${weight.weight} kg',
          style: titleMediumTextWithColor(
            context: context,
            color: color[900] as Color,
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
