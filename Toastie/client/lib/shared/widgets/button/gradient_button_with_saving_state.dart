import 'package:flutter/material.dart';
import 'package:toastie/components/button/button.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';

GradientButtonWithSavingState({
  required BuildContext context,
  required bool isSaving,
  required Future<void> Function() onPressed,
  String buttonText = 'Save',
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: gridbaseline * 2),
      child: isSaving
          ? Button(
              buttonType: ButtonType.SavingButton,
              text: 'Saving...',
              color: neutral,
              actionHandler: () => {},
              fullWidth: false,
            )
          : GradientButton(
              actionHandler: () async {
                await onPressed();
              },
              gradient: gradientButtonMain,
              text: buttonText,
              withTopPadding: false,
            ),
    ),
  );
}
