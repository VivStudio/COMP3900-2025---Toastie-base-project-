import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class ErrorMessageCard extends StatelessWidget {
  ErrorMessageCard({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(gridbaseline),
        ),
        color: critical[100],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: gridbaseline * 2,
          vertical: gridbaseline,
        ),
        child: Wrap(
          spacing: gridbaseline,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: critical,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: neutral[900]),
            ),
          ],
        ),
      ),
    );
  }
}
