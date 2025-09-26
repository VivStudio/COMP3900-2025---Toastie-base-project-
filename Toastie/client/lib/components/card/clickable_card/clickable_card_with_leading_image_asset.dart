import 'package:flutter/material.dart';
import 'package:toastie/components/card/clickable_card/clickable_base_card.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/utils.dart';

class ClickableCardWithLeadingImageAsset extends StatelessWidget {
  ClickableCardWithLeadingImageAsset({
    required this.title,
    required this.color,
    required this.assetName,
    required this.cardAction,
  });

  final String title;
  final MaterialColor color;
  final String assetName;
  final VoidCallback cardAction;

  @override
  Widget build(BuildContext context) {
    return ClickableBaseCard(
      title: capitalizeFirstCharacter(title),
      leadingWidget: Image(
        image: AssetImage(assetName),
        height: gridbaseline * 3,
        fit: BoxFit.fitHeight,
      ),
      solidColor: color[100]!,
      textColor: color[900]!,
      iconFillColor: color[400]!,
      cardAction: cardAction,
    );
  }
}
