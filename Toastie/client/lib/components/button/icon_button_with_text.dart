import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

class IconButtonWithText extends StatelessWidget {
  IconButtonWithText({
    required this.iconData,
    required this.text,
    required this.buttonColor,
    required this.contentColor,
    required this.actionHandler,
    this.fullWidth = true,
    this.horizontalPadding,
    this.endIcon,
  });

  final IconData iconData;
  final String text;
  final Function() actionHandler;
  final Color buttonColor;
  final Color contentColor;
  final bool fullWidth;
  final double? horizontalPadding;
  final IconData? endIcon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: actionHandler,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.hovered)) {
              return primary;
            }
            return buttonColor;
          },
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? gridbaseline * 3,
          ),
        ),
      ).merge(
        FilledButton.styleFrom(
          shape: roundedRectangleBorder,
          elevation: 0,
        ),
      ),
      child: Wrap(
        spacing: gridbaseline / 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Icon(
            iconData,
            color: contentColor,
            size: scaleBySystemFont(context: context, size: 18),
          ),
          Text(
            text,
            style: bodyLargeTextWithColor(context: context, color: contentColor)
                .copyWith(height: 1.2),
            overflow: TextOverflow.visible,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
          Visibility(
            visible: endIcon != null,
            child: Icon(
              endIcon,
              color: contentColor,
              size: scaleBySystemFont(context: context, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
