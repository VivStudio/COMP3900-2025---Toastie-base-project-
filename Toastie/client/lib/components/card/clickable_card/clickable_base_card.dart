import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

class ClickableBaseCard extends StatelessWidget {
  ClickableBaseCard({
    required this.title,
    required this.textColor,
    required this.iconFillColor,
    required this.cardAction,
    // Widget to the right of the text.
    this.leadingWidget,
    this.solidColor,
    this.gradientColor,
  }) : assert(
          (solidColor == null) != (gradientColor == null),
          'You must provide either a color or a gradient, but not both.',
        );

  final String title;
  final Color textColor;
  final Color iconFillColor;
  final VoidCallback cardAction;
  final Widget? leadingWidget;
  final Color? solidColor;
  final Gradient? gradientColor;

  Widget CardContent({
    required BuildContext context,
  }) {
    return Padding(
      padding: cardLargeInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Visibility(
                visible: leadingWidget != null,
                child:
                    leadingWidget != null ? leadingWidget! : SizedBox.shrink(),
              ),
              SizedBox(width: gridbaseline),
              Expanded(
                child: Text(
                  title,
                  style: gradientColor != null
                      ? titleMediumTextWithColor(
                          context: context,
                          color: textColor,
                        ).copyWith(fontWeight: FontWeight.bold)
                      : titleMediumTextWithColor(
                          context: context,
                          color: textColor,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      solidColor: solidColor,
      gradientColor: gradientColor,
      actionHandler: cardAction,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CardContent(
                context: context,
              ),
            ),
            Padding(
              padding: cardRightPadding,
              child: ToastieIconButton(
                actionHandler: cardAction,
                iconType: IconType.NavigateNext,
                iconSize: IconSize.Card,
                iconButtonType: IconButtonType.FilledButton,
                iconColor: Colors.white,
                fillColor: iconFillColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
