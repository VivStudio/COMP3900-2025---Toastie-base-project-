import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

enum SnackBarType {
  error,
  success,
}

void showGenericToastieSnackBar({required BuildContext context}) {
  ToastieSnackBar.showWithCloseIcon(
    type: SnackBarType.error,
    message: 'Opps! Something went wrong. Please try again!',
    context: context,
  );
}

class ToastieSnackBar {
  static void showWithCloseIcon({
    required SnackBarType type,
    required String message,
    required BuildContext context,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Color backgroundColor = neutral;
    switch (type) {
      case SnackBarType.error:
        backgroundColor = critical;
        break;
      case SnackBarType.success:
        backgroundColor = success;
        break;
    }

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      showCloseIcon: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
