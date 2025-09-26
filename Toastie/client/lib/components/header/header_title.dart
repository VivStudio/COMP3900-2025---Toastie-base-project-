import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text_utils.dart';

class HeaderTitle extends StatelessWidget {
  HeaderTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return GradientTextWithTwoColors(
      text: title,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontFamily: libreBaskerVilleFont,
          ),
    );
  }
}
