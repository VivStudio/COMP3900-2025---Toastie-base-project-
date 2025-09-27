import 'package:flutter/material.dart';
import 'package:toastie/features/assistant/assistant.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';
import 'package:toastie/utils/responsive_utils.dart';

class MagicTracker extends StatelessWidget {
  MagicTracker({
    required this.date,
    required this.reloadHomePage,
  });

  final DateTime date;
  final Function() reloadHomePage;

  @override
  Widget build(BuildContext context) {
    void _navigateToAssistant() {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => AssistantScreen(),
        ),
      )
          .then((value) {
        reloadHomePage();
      });
    }

    return FractionallySizedBox(
      widthFactor:
          isTabletFromSize(size: MediaQuery.of(context).size) ? 0.7 : 1,
      child: GestureDetector(
        onTap: _navigateToAssistant,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradientButtonMain,
          ),
          child: Padding(
            padding: cardLargeInnerPadding,
            child: Text(
              'TODO: 9900-W09D-BREAD Implement Toastie Magic Tracker v2 here',
            ),
          ),
        ),
      ),
    );
  }
}
