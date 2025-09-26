import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toastie/components/button/gradient_button.dart';
import 'package:toastie/navigation/app_navigation_utils.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

class NoInsights extends StatelessWidget {
  NoInsights({required this.textColor});

  final MaterialColor textColor;

  void navigateToMagicTrackers({required BuildContext context}) {
    // TODO: ideally like it to go to the magic tracker on the home page tab (and something else for free users).
    GoRouter.of(context).go(homePath);
  }

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
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: gridbaseline,
            children: [
              Text(
                'No insights yet',
                textAlign: TextAlign.center,
                style: titleMediumTextWithColor(
                  context: context,
                  color: textColor[900]!,
                ),
              ),
              Text(
                'Right now, there is no data to generate insights 🍞🌱',
                textAlign: TextAlign.center,
                style: bodyMediumTextWithColor(
                  context: context,
                  color: textColor[700]!,
                ),
              ),
            ],
          ),
          GradientButton(
            actionHandler: () => navigateToMagicTrackers(context: context),
            fullWidth: false,
            gradient: gradientButtonMain,
            text: 'Start tracking',
          ),
        ],
      ),
    );
  }
}
