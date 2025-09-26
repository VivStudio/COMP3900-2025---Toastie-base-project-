import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/tracker_utils.dart';
import 'package:toastie/utils/layout/padding.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({
    required this.type,
    required this.date,
    required this.reloadHomePage,
    this.onSummaryCardTap,
    this.summaryDetails,
    this.child = const SizedBox.shrink(),
  });

  final TrackerCategory type;
  final DateTime date;
  final Future<void> Function() reloadHomePage;
  // If null, it will navigate for manual tracker.
  // This is preferred for categories such as period, weight and note tracking since it is easier and cleaner to just edit those details there as opposed to the summary page.
  // OR for categories that don't have anything logged yet.
  final VoidCallback? onSummaryCardTap;
  final String? summaryDetails;
  final Widget child;

  void _navigateToTracker({
    required BuildContext context,
  }) {
    // No-op.
  }

  Widget CardContent({
    required BuildContext context,
    required MaterialColor containerColor,
  }) {
    final String imageIcon =
        getImageAssetNameFromTrackerCategory(category: type);
    return Padding(
      padding: cardLargeInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Image(
                image: AssetImage(imageIcon),
                height: gridbaseline * 3,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(width: gridbaseline),
              Text(
                getTrackerName(type),
                style: titleMediumTextWithColor(
                  context: context,
                  color: containerColor[900] as Color,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryDetails.toString().isNotEmpty
                  ? Text(
                      summaryDetails.toString(),
                      style: bodyMediumTextWithColor(
                        context: context,
                        color: neutral[900] as Color,
                      ),
                    )
                  : SizedBox.shrink(),
              child,
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaterialColor containerColor =
        getColorFromTrackerCategory(category: type);
    return BaseCard(
      solidColor: containerColor[100]!,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CardContent(
                context: context,
                containerColor: containerColor,
              ),
            ),
            Padding(
              padding: cardRightPadding,
              child: ToastieIconButton(
                actionHandler: () => _navigateToTracker(context: context),
                iconType: IconType.Add,
                iconSize: IconSize.Card,
                iconButtonType: IconButtonType.FilledButton,
                iconColor: Colors.white,
                fillColor: containerColor[400]!,
              ),
            ),
          ],
        ),
      ),
      actionHandler: onSummaryCardTap != null
          ? onSummaryCardTap
          : () => _navigateToTracker(context: context),
    );
  }
}
