import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class AuthenticationButton extends StatelessWidget {
  AuthenticationButton({
    required this.providerImage,
    required this.text,
    required this.actionHandler,
  });

  final Widget providerImage;
  final String text;
  final Future<void> Function() actionHandler;

  void performAction() async {
    await actionHandler();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: performAction,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return neutral[200];
            }
            if (states.contains(WidgetState.hovered)) {
              return neutral[100];
            }
            return Colors.white;
          },
        ),
      ).merge(
        OutlinedButton.styleFrom(
          foregroundColor: neutral,
          minimumSize: buttonWidth(context, true),
          shape: StadiumBorder(),
          side: BorderSide(color: neutral.shade400),
          textStyle: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: gridbaseline * 2),
            child: providerImage,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
