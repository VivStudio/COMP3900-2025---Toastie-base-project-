import 'package:flutter/material.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';

void openDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  String? buttonText,
  VoidCallback? actionHandler,
  LinearGradient? gradientColor,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: gradientColor != null
              ? Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: gradientColor != null
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: actionHandler != null && buttonText != null
            ? [
                GradientButton(
                  actionHandler: actionHandler,
                  gradient: gradientColor ?? gradientButtonMain,
                  text: buttonText,
                  withTopPadding: false,
                ),
              ]
            : null,
      );
    },
  );
}
