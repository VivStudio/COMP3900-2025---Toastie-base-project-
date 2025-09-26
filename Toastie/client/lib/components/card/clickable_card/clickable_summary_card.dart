import 'package:flutter/material.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:toastie/utils/responsive_utils.dart';

class ClickableSummaryCard extends StatelessWidget {
  const ClickableSummaryCard({
    required this.solidColor,
    required this.defaultCardContents,
    required this.stackedCardContents,
    required this.actionHandler,
  });

  final Color? solidColor;
  final Widget defaultCardContents;
  final Widget stackedCardContents;
  final Function() actionHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: cardOuterPadding,
      child: BaseCard(
        solidColor: solidColor,
        actionHandler: actionHandler,
        child: Padding(
          padding: cardLargeInnerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              shouldAdaptForAccessibility(context: context)
                  ? stackedCardContents
                  : defaultCardContents,
            ],
          ),
        ),
      ),
    );
  }
}
