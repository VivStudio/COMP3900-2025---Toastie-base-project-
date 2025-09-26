import 'package:flutter/material.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/components/header/header_title.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/themes/text/text_utils.dart';
import 'package:toastie/utils/grid.dart';

class HeaderTitleWithBackButton extends StatelessWidget {
  HeaderTitleWithBackButton({
    required this.title,
    required this.backButtonClicked,
    MaterialColor? color,
  }) : color = color ?? null;

  final String title;
  final VoidCallback backButtonClicked;
  // If text color is not set, show gradient text instead.
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ToastieIconButton(
                iconType: IconType.Back,
                actionHandler: backButtonClicked,
                iconColor: color != null ? color![600]! : primary,
              ),
            ),
            Padding(
              // TODO: this is not good, think of a better way to do this.
              // To note: We want the title text to be centered, but if you just blindly make it centered, it'll be automatically off-center because of the right icon.
              // That's why we can't put this in a row, or wrap and must be a stack instead.

              // We add padding so that the text will be centered if we block out the horizontal padding with the icon dimensions.
              padding: EdgeInsets.symmetric(
                horizontal: (smallIconSize + gridbaseline * 4),
              ),
              child: color != null
                  ? Text(
                      title,
                      textAlign: TextAlign.center,
                      style: headlineLargeWithColor(
                        context: context,
                        color: color![600]!,
                        fontFamily: ToastieFontFamily.libreBaskerville,
                      ),
                    )
                  : HeaderTitle(title: title),
            ),
          ],
        ),
        SizedBox(height: gridbaseline),
      ],
    );
  }
}
