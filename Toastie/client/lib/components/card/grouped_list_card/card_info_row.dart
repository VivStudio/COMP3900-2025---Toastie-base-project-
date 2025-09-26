import 'package:flutter/material.dart';
import 'package:toastie/components/card/grouped_list_card/base_card_info_row.dart';

class CardInfoRow extends StatelessWidget {
  CardInfoRow({
    required this.title,
    required this.description,
    required this.textColor,
  });

  final String title;
  final String description;
  final MaterialColor textColor;

  @override
  Widget build(BuildContext context) {
    return BaseCardInfoRow(
      title: title,
      titleTextColor: textColor[600] as Color,
      description: description,
      descriptionTextColor: textColor[400] as Color,
    );
  }
}
