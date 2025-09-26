import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/utils.dart';

enum TrackerToggleButtonType {
  leftBorderRadius,
  noBorderRadius,
  rightBorderRadius,
}

class TrackerToggleButton<Severity> extends StatelessWidget {
  TrackerToggleButton({
    required this.severity,
    required this.onPressed,
    this.buttonType = TrackerToggleButtonType.noBorderRadius,
    this.color = primary,
    this.isSelected = false,
  });

  final MaterialColor color;
  final TrackerToggleButtonType buttonType;
  final Severity severity;
  final Function onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => onPressed(severity),
      style: ButtonStyle(
        // Button background color.
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return isSelected ? color[500] : color[100];
        }),
        // Highlight color that's typically used to indicate that the button is
        // focused, hovered, or pressed.
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed)) {
            return isSelected ? color[700] : color[500];
          }
          return isSelected ? color[600] : color[400];
        }),
        surfaceTintColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return isSelected ? color[600] : color[500];
        }),
        // Text color.
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return isSelected ? Colors.white : color[500];
        }),
        // Outline color.
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          (states) {
            return BorderSide(
              color: color,
            );
          },
        ),
        // Border shape.
        shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
          (states) {
            return switch (buttonType) {
              TrackerToggleButtonType.leftBorderRadius =>
                RoundedRectangleBorder(borderRadius: leftBorderRadius),
              TrackerToggleButtonType.noBorderRadius =>
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              TrackerToggleButtonType.rightBorderRadius =>
                RoundedRectangleBorder(borderRadius: rightBorderRadius),
            };
          },
        ),
      ),
      child: Text(
        '${capitalizeFirstCharacter(severity.toString().split('.')[1])}',
      ),
    );
  }
}
