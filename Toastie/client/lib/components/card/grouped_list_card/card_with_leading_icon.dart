import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

class CardWithLeadingIcon extends StatelessWidget {
  CardWithLeadingIcon({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(gridbaseline),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: primary,
          ),
          SizedBox(width: gridbaseline),
          Expanded(
            child: Text(
              text,
              style: titleSmallTextWithColor(
                context: context,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
