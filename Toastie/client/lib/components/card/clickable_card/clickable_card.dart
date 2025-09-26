import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_base_card.dart';
import 'package:toastie/utils/utils.dart';

class ClickableCard extends StatelessWidget {
  ClickableCard({
    required this.title,
    required this.color,
    required this.cardAction,
  });

  final String title;
  final MaterialColor color;
  final VoidCallback cardAction;

  @override
  Widget build(BuildContext context) {
    return ClickableBaseCard(
      title: capitalizeFirstCharacter(title),
      solidColor: Colors.white,
      textColor: color[700]!,
      iconFillColor: color,
      cardAction: cardAction,
    );
  }
}
