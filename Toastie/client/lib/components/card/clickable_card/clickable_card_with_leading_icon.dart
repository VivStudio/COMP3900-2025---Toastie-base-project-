import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_base_card.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/linear_gradient_colors.dart';

class ClickableCardWithLeadingIcon extends StatelessWidget {
  ClickableCardWithLeadingIcon({
    required this.leadingIcon,
    required this.title,
    required this.cardAction,
  });

  final IconData leadingIcon;
  final String title;
  final VoidCallback cardAction;

  @override
  Widget build(BuildContext context) {
    return ClickableBaseCard(
      title: title,
      leadingWidget: Icon(
        leadingIcon,
        color: Colors.white,
      ),
      textColor: Colors.white,
      iconFillColor: primary[700] as Color,
      cardAction: cardAction,
      gradientColor: gradientButtonMainYellowFadeEarlier,
    );
  }
}
