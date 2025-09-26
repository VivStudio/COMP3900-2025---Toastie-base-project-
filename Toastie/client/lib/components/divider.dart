import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class ToastieDivider extends StatelessWidget {
  ToastieDivider({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: neutral[300],
            height: gridbaseline * 4,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gridbaseline * 2),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: neutral),
          ),
        ),
        Expanded(
          child: Divider(
            color: neutral[300],
            height: gridbaseline * 4,
          ),
        ),
      ],
    );
  }
}
