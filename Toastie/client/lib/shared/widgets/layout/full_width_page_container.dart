import 'package:flutter/material.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/utils/layout/grid.dart';

// Define consistent paddings across all the full width page containers.
double FullWidthPageHorizontalPadding = gridbaseline * 2;
EdgeInsets FullWidthPagePadding =
    EdgeInsets.symmetric(horizontal: FullWidthPageHorizontalPadding);

class FullWidthPageContainer extends StatelessWidget {
  FullWidthPageContainer({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: primaryLighterGradientBackground,
          child: Center(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
