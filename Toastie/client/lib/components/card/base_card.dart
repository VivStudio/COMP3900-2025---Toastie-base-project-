/*
 * Base card component. All variations of a card should be built on top of this component.
 */
import 'package:flutter/material.dart';
import 'package:toastie/utils/grid.dart';

class BaseCard extends StatelessWidget {
  BaseCard({
    required this.child,
    this.solidColor,
    this.gradientColor,
    this.border = null,
    this.actionHandler = null,
  }) : assert(
          (solidColor == null) != (gradientColor == null),
          'You must provide either a color or a gradient, but not both.',
        );

  final Color? solidColor;
  final Gradient? gradientColor;
  final Widget child;
  final BorderSide? border;
  final Function()? actionHandler;

  // Do not add any extra styling to this card. Padding etc. should be passed in through the child.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.actionHandler != null) {
          this.actionHandler!();
        }
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: ShapeDecoration(
          color: solidColor,
          gradient:
              gradientColor, // Internally, Flutter renders the gradient on top of the color.
          shape: border != null
              ? RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: border!,
                )
              : RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
        ),
        child: child,
      ),
    );
  }
}
