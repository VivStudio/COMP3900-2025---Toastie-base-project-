import 'package:flutter/material.dart';
import 'package:toastie/themes/text/text_utils.dart';

// Display text.
TextStyle displayLargeTextWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.displayLarge!.copyWith(
        color: color,
        height: textVerticalSpacing,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

TextStyle displayMediumTextWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.displayMedium!.copyWith(
        color: color,
        height: textVerticalSpacing,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

// Headline text.
TextStyle headlineLargeWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.headlineLarge!.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

TextStyle headlineMediumWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.headlineLarge!.copyWith(
        color: color,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

double textVerticalSpacing = 1.2;

// Title text.
TextStyle titleLargeTextWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: color,
        height: textVerticalSpacing,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

TextStyle titleMediumTextWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
        color: color,
        height: textVerticalSpacing,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

TextStyle titleSmallTextWithColor({
  required BuildContext context,
  required Color color,
  ToastieFontFamily fontFamily = ToastieFontFamily.ttNorms,
}) {
  return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: color,
        height: textVerticalSpacing,
        fontFamily: toastieFontFamilyMap[fontFamily],
      );
}

// Body text.
TextStyle bodyLargeTextWithColor({
  required BuildContext context,
  required Color color,
}) {
  return Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

TextStyle bodyMediumTextWithColor({
  required BuildContext context,
  required Color color,
}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

TextStyle bodySmallTextWithColor({
  required BuildContext context,
  required Color color,
}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

// Label text.
TextStyle labelLargeTextWithColor(BuildContext context, Color color) {
  return Theme.of(context).textTheme.labelLarge!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

TextStyle labelMediumTextWithColor(BuildContext context, Color color) {
  return Theme.of(context).textTheme.labelMedium!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

TextStyle labelSmallTextWithColor(BuildContext context, Color color) {
  return Theme.of(context).textTheme.labelSmall!.copyWith(
        color: color,
        height: textVerticalSpacing,
      );
}

TextStyle graphTooltipTextStyle() {
  return TextStyle(
    color: Colors.white, // Text color
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
}
