import 'package:flutter/material.dart';
import 'package:toastie/utils/grid.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    required this.gradient,
    required this.actionHandler,
    this.text = '',
    this.child = null,
    this.fullWidth = false,
    this.withTopPadding = true,
    this.withOutline = false,
  });

  // GradientButton should take in either a text OR child, not both.
  final String text;
  final Widget? child;
  final LinearGradient gradient;
  final void Function() actionHandler;
  final bool fullWidth;
  final bool withTopPadding;
  final bool withOutline;

  @override
  Widget build(BuildContext context) {
    return filledGradientButton(context);
  }

  Widget filledGradientButton(BuildContext context) {
    return Column(
      children: [
        if (withTopPadding) SizedBox(height: gridbaseline * 4),
        Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: gradient,
              border: withOutline
                  ? Border.all(
                      color: Colors.white,
                      width: 1.0,
                    )
                  : null,
            ),
            child: FilledButton(
              onPressed: actionHandler,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                minimumSize: buttonWidth(context, fullWidth),
                shape: StadiumBorder(),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              child: text.isNotEmpty
                  ? Text(
                      text,
                      textAlign: TextAlign.center,
                    )
                  : child,
            ),
          ),
        ),
      ],
    );
  }
}
