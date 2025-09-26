import 'package:flutter/material.dart';
import 'package:toastie/components/card/grouped_list_card/base_card_info_row.dart';

class ClickableCardInfoRow extends StatelessWidget {
  ClickableCardInfoRow({
    required this.title,
    required this.textColor,
    required this.actionHandler,
    this.description,
  });

  final String title;
  final String? description;
  final MaterialColor textColor;
  final VoidCallback actionHandler;

  @override
  Widget build(BuildContext context) {
    Color color = textColor[600] as Color;
    return BaseCardInfoRow(
      title: title,
      titleTextColor: color,
      description: description,
      descriptionTextColor: color,
      actionHandler: actionHandler,
    );
  }
}
