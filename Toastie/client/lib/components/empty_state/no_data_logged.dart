import 'package:flutter/material.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

class NoDataLogged extends StatelessWidget {
  NoDataLogged({
    required this.textColor,
    required this.subtitleText,
    required this.actionHandler,
    this.ctaText = 'Start tracking',
  });

  final MaterialColor textColor;
  final String subtitleText;
  final VoidCallback actionHandler;
  final String ctaText;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          ClipOval(
            child: Image(
              image: AssetImage('assets/track.png'),
              height: headerImageSize(context),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: gridbaseline * 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nothing yet',
                textAlign: TextAlign.center,
                style: titleMediumTextWithColor(
                  context: context,
                  color: textColor[900]!,
                ),
              ),
              SizedBox(height: gridbaseline),
              Text(
                subtitleText,
                textAlign: TextAlign.center,
                style: bodyMediumTextWithColor(
                  context: context,
                  color: textColor[700]!,
                ),
              ),
            ],
          ),
          GradientButton(
            actionHandler: actionHandler,
            fullWidth: false,
            gradient: gradientButtonMain,
            text: ctaText,
          ),
        ],
      ),
    );
  }
}
