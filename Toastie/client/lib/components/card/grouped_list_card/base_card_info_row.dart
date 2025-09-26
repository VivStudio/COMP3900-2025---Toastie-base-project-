import 'package:flutter/material.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/themes/theme.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/layout/padding.dart';

class BaseCardInfoRow extends StatelessWidget {
  BaseCardInfoRow({
    required this.title,
    required this.titleTextColor,
    this.description,
    this.descriptionTextColor,
    this.actionHandler,
  }) : assert(
          description == null || descriptionTextColor != null,
          'If description is provided, descriptionTextColor must also be provided.',
        );

  final String title;
  final Color titleTextColor;
  final String? description;
  final Color? descriptionTextColor;
  final VoidCallback? actionHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.actionHandler != null) {
          this.actionHandler!();
        }
      },
      child: Padding(
        padding: cardLargeInnerPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleSmallTextWithColor(
                context: context,
                color: titleTextColor,
              ),
            ),
            Visibility(
              visible: description != null,
              child: Row(
                children: [
                  SizedBox(width: gridbaseline),
                  Text(
                    description.toString(),
                    style: titleSmallTextWithColor(
                      context: context,
                      color: descriptionTextColor!,
                    ).copyWith(
                      fontWeight: actionHandler != null
                          ? FontWeight.bold
                          : fontWeightMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
