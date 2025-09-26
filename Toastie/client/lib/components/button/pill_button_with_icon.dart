import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button_with_text.dart';

class PillButtonWithIcon extends StatelessWidget {
  PillButtonWithIcon({
    required this.color,
    required this.text,
    required this.actionHandler,
  });

  final MaterialColor color;
  final String text;
  final Function() actionHandler;

  @override
  Widget build(BuildContext context) {
    return IconButtonWithText(
      iconData: Icons.add_circle_outline,
      text: text,
      buttonColor: color[200] as Color,
      contentColor: color[700] as Color,
      actionHandler: actionHandler,
    );
  }
}
