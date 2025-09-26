import 'package:flutter/widgets.dart';

bool isTablet({required BuildContext context}) {
  return MediaQuery.of(context).size.shortestSide >= 600;
}

bool isTabletFromSize({required Size size}) {
  return size.shortestSide >= 600;
}

double scaleBySystemFont({
  required BuildContext context,
  required double size,
}) {
  return MediaQuery.of(context).textScaler.scale(size);
}

double scaleBySystemFontWithMultiplier({
  required BuildContext context,
  required double size,
}) {
  final double scale = MediaQuery.of(context).textScaler.scale(1.0);
  if (scale >= 1.5 && scale <= 2) {
    return MediaQuery.of(context).textScaler.scale(size) * 4;
  }
  if (scale > 2.0) {
    return MediaQuery.of(context).textScaler.scale(size) * 8;
  } else {
    return size;
  }
}

// Checks the system text scale and triggeres a stacked for better accessibility.
// The layout logic is handled by each view.
bool shouldAdaptForAccessibility({required BuildContext context}) {
  final double textScale = MediaQuery.of(context).textScaler.scale(1.0);
  return textScale >= 1.5;
}
