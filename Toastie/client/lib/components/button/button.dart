import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

enum ButtonType {
  FilledButton,
  OutlinedButton,
  TextButton,
  SavedButton,
  SavingButton,
  DisabledButton,
}

class Button extends StatelessWidget {
  Button({
    required this.buttonType,
    required this.text,
    required this.color,
    required this.actionHandler,
    this.fullWidth = false,
    this.icon,
  });

  final ButtonType buttonType;
  final String text;
  final MaterialColor color;
  final Function() actionHandler;
  final fullWidth;
  final IconData? icon;

  final double loadingAnimationIconSize = gridbaseline * 3;

  @override
  Widget build(BuildContext context) {
    return switch (buttonType) {
      ButtonType.OutlinedButton => outlinedButton(context),
      ButtonType.FilledButton => filledButton(context),
      ButtonType.TextButton => textButton(context),
      ButtonType.SavedButton => savedButton(context),
      ButtonType.SavingButton => savingButton(context),
      ButtonType.DisabledButton => disabledButton(context: context),
    };
  }

  Widget outlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: actionHandler,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return color;
            }
            if (states.contains(WidgetState.hovered)) {
              return neutral[400];
            }
            return Colors.white;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return Colors.white;
          }
          return color;
        }),
      ).merge(
        OutlinedButton.styleFrom(
          minimumSize: buttonWidth(context, false),
          shape: roundedRectangleBorder,
          side: BorderSide(color: color),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      child: Text(text),
    );
  }

  Widget filledButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(gridbaseline),
      child: FilledButton(
        onPressed: actionHandler,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return color[300];
              }
              if (states.contains(WidgetState.hovered)) {
                return color[200];
              }
              return color[100];
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return color[900];
          }),
        ).merge(
          FilledButton.styleFrom(
            elevation: 0,
            minimumSize: buttonWidth(context, fullWidth),
            shape: roundedRectangleBorder,
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget textButton(BuildContext context) {
    return FilledButton(
      onPressed: actionHandler,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return color[100];
            }
            return Colors.transparent;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            return color[600];
          },
        ),
      ).merge(
        FilledButton.styleFrom(
          elevation: 0,
          shape: roundedRectangleBorder,
          textStyle: labelLargeTextWithColor(context, color),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          icon != null ? Icon(icon) : SizedBox.shrink(),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget disabledButton({
    required BuildContext context,
    List<Widget> children = const [],
  }) {
    return Column(
      children: [
        FilledButton(
          onPressed: actionHandler,
          style: FilledButton.styleFrom(
            elevation: 0,
            backgroundColor: neutral[300],
            foregroundColor: Colors.white,
            minimumSize: buttonWidth(context, fullWidth),
            shape: roundedRectangleBorder,
            textStyle: Theme.of(context).textTheme.titleMedium,
            splashFactory: NoSplash.splashFactory,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...children,
              Padding(
                padding: EdgeInsets.only(left: gridbaseline),
                child: Text(text),
              ),
              // Ensures that the text is in the center of the button (add loadingAnimationIconSize to the left and right of the text).
              SizedBox(
                height: loadingAnimationIconSize,
                width: loadingAnimationIconSize,
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget savedButton(BuildContext context) {
    return disabledButton(
      context: context,
      children: [
        Icon(
          Icons.check,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget savingButton(BuildContext context) {
    return disabledButton(
      context: context,
      children: [
        SizedBox(
          height: loadingAnimationIconSize,
          width: loadingAnimationIconSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 3,
          ),
        ),
        SizedBox(width: gridbaseline),
      ],
    );
  }
}
