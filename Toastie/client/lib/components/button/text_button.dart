import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';

// DEPRECATED - use Button type TextButton instead
class ToastieTextButton extends StatelessWidget {
  ToastieTextButton({
    required this.text,
    required this.actionHandler,
    this.color = primary,
    this.underline = false,
  });

  final String text;
  final Function() actionHandler;
  final Color color;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: actionHandler,
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                decorationColor: color,
              ),
        ),
      ),
    );
  }
}
