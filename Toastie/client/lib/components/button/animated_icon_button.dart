import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';

class ToastieIconButton extends StatelessWidget {
  ToastieIconButton({
    required this.actionHandler,
    // this.toolTip,
    this.fillColor = accentPink,
  }) {}

  final Function() actionHandler;
  // final String? toolTip;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
      ),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
        strokeWidth: 3,
      ),
    );
  }
}
