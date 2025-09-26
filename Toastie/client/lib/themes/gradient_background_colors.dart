import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';

/* Gradient for the start screen. */
BoxDecoration primaryAndSecondaryGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF9C5),
      Color(0xFFFFD595),
      Color(0xFFFFB495),
      accentPink,
    ],
    stops: [0.1, 0.4, 0.6, 1.0],
  ),
);

/* Gradient for the home screen. */
BoxDecoration primaryGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.center,
    colors: [
      accentPink[300] as Color,
      primary[200] as Color,
      primary[100] as Color,
      Colors.white,
    ],
  ),
);

/* Gradient for the main screens. */
BoxDecoration primaryLighterGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      primary[100] as Color,
      Colors.white,
    ],
  ),
);

BoxDecoration primaryToNeutralGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      primary[100] as Color,
      neutral[100] as Color,
    ],
  ),
);

/********** Gradient page colors **********/

const Color neutralPageColor = Color(0xFFF2F1F6);

BoxDecoration primaryAndNeutralGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primary[200]!,
      neutralPageColor,
    ],
  ),
);

BoxDecoration accentPinkAndNeutralGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      accentPink[200]!,
      neutralPageColor,
    ],
  ),
);

// TODO: please make sure we fix the accent yellow shade before using this.
BoxDecoration accentYellowAndNeutralGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      accentYellow[200]!,
      neutralPageColor,
    ],
  ),
);

BoxDecoration infoNeutralAndPrimaryGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      info[200]!,
      neutralPageColor,
      primary[100]!,
    ],
  ),
);

BoxDecoration successNeutralAndPrimaryGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      success[200]!,
      neutralPageColor,
      primary[100]!,
    ],
  ),
);
