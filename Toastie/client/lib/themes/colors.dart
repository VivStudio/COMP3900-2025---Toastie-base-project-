import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

/* Light mode colors */

const Color toastBrown = Color(0xFFAA6C3D);

GradientText GradientTextWithThreeColors({
  required String text,
  required TextStyle? style,
}) {
  return GradientText(
    text,
    style: style,
    colors: [
      accentYellow,
      primary,
      accentPink[600] as Color,
    ],
    textAlign: TextAlign.center,
  );
}

GradientText GradientTextWithTwoColors({
  required String text,
  required TextStyle? style,
}) {
  return GradientText(
    text,
    style: style,
    colors: [
      primary,
      accentPink[600] as Color,
    ],
    textAlign: TextAlign.center,
  );
}

/* All colors */
List<MaterialColor> colors = [
  accentYellow,
  primary,
  accentPink,
  critical,
  info,
  success,
];

/* Primary colors (orange) */
const MaterialColor primary = MaterialColor(
  0xFFFF8551,
  <int, Color>{
    50: Color(0xFFDCB9),
    100: Color(0xFFFFEFDC),
    200: Color(0xFFFFDCB9),
    300: Color(0xFFFFC396),
    400: Color(0xFFFFAC7C),
    500: Color(0xFFFF8551),
    600: Color(0xFFDB603B),
    700: Color(0xFFB74028),
    800: Color(0xFF932519),
    900: Color(0xFF7A120F),
  },
);

/* Accent colors (yellow) */
const MaterialColor accentYellow = MaterialColor(
  0xFFFFEC3F,
  <int, Color>{
    100: Color(0xFFFFFBCC),
    200: Color(0xFFFFF799),
    300: Color(0xFFFFF266),
    400: Color(0xFFFFEC3F),
    500: Color(0xFFFFE400),
    600: Color(0xFFDBC100),
    700: Color(0xFFB7A000),
    800: Color(0xFF937F00),
    900: Color(0xFF7A6800),
  },
);

/* Accent colors (pink) */
const MaterialColor accentPink = MaterialColor(
  0xFFFF8080,
  <int, Color>{
    100: Color(0xFFFFEEE5),
    200: Color(0xFFFFD9CC),
    300: Color(0xFFFFBFB2),
    400: Color(0xFFFFA79F),
    500: Color(0xFFFF8080),
    600: Color(0xFFDB5D68),
    700: Color(0xFFB74055),
    800: Color(0xFF932844),
    900: Color(0xFF7A183A),
  },
);

/* Success colors (green) */
const MaterialColor success = MaterialColor(
  0xFF7BD14D,
  <int, Color>{
    100: Color(0xFFEFFCDC),
    200: Color(0xFFDDFABB),
    300: Color(0xFFC1F195),
    400: Color(0xFFA4E377),
    500: Color(0xFF7BD14D),
    600: Color(0xFF5BB338),
    700: Color(0xFF3F9626),
    800: Color(0xFF277918),
    900: Color(0xFF17640E),
  },
);

/* Info colors (blue) */
const MaterialColor info = MaterialColor(
  0xFF47AFFF,
  <int, Color>{
    100: Color(0xFFDAF7FF),
    200: Color(0xFFB5EBFF),
    300: Color(0xFF90DBFF),
    400: Color(0xFF75CAFF),
    500: Color(0xFF47AFFF),
    600: Color(0xFF3389DB),
    700: Color(0xFF2366B7),
    800: Color(0xFF164893),
    900: Color(0xFF0D327A),
  },
);

/* Warning colors (yellow) */
const MaterialColor warning = MaterialColor(
  0xFFF7E138,
  <int, Color>{
    100: Color(0xFFFEFBD7),
    200: Color(0xFFFEF7AF),
    300: Color(0xFFFCF187),
    400: Color(0xFFFAEB69),
    500: Color(0xFFF7E138),
    600: Color(0xFFD4BE28),
    700: Color(0xFFB19D1C),
    800: Color(0xFF8F7C11),
    900: Color(0xFF76640A),
  },
);

/* Critical colors (red) */
const MaterialColor critical = MaterialColor(
  0xFFD84747,
  <int, Color>{
    100: Color(0xFFFBEDED),
    200: Color(0xFFEFB5B5),
    300: Color(0xFFE89191),
    400: Color(0xFFE06C6C),
    500: Color(0xFFD84747),
    600: Color(0xFFAD3939),
    700: Color(0xFF973232),
    800: Color(0xFF822B2B),
    900: Color(0xFF6C2424),
  },
);

/* Purple */
const MaterialColor purple = MaterialColor(
  0xFFC252FF,
  <int, Color>{
    100: Color(0xFFF9EEFF),
    200: Color(0xFFE1A9FF),
    300: Color(0xFFDA97FF),
    400: Color(0xFFCE75FF),
    500: Color(0xFFC252FF),
    600: Color(0xFF9B42CC),
    700: Color(0xFF8839B3),
    800: Color(0xFF743199),
    900: Color(0xFF612980),
  },
);

/* Neutral colors (grey) */
const MaterialColor neutral = MaterialColor(
  0xFF424242,
  <int, Color>{
    100: Color(0xFFF5F5F5),
    200: Color(0xFFECECEC),
    300: Color(0xFFC6C6C6),
    400: Color(0xFF8D8D8D),
    500: Color(0xFF424242),
    600: Color(0xFF383030),
    700: Color(0xFF2F2123),
    800: Color(0xFF261519),
    900: Color(0xFF1F0C13),
  },
);

const MaterialColor containerNavy = MaterialColor(
  0xFF3C5E7D,
  <int, Color>{
    50: Color(0xFFE2E7EC),
    100: Color(0xFFBBC9D6),
    200: Color(0xFF8FA8BA),
    300: Color(0xFF67879F),
    400: Color(0xFF3C5E7D),
    500: Color(0xFF2C435A),
    600: Color(0xFF1C2C3A),
    700: Color(0xFF101C24),
    800: Color(0xFF071114),
    900: Color(0xFF02090A),
  },
);
