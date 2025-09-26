import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/layout/border_radius.dart';

enum CalendarDayType {
  normal,
  today,
  selected,
}

enum CalendarPeriodDayType {
  none,
  start,
  middle,
  end,
  single,
}

(Color, TextStyle) sharedPeriodStyling({
  required Color? containerColor,
  required TextStyle textStyle,
}) {
  Color containerColor = accentPink[400] as Color;
  TextStyle updatedTextStyle = textStyle.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  return (containerColor, updatedTextStyle);
}

(Color?, TextStyle, BorderRadius) applyPeriodStyling({
  required CalendarPeriodDayType periodDayType,
  required Color? containerColor,
  required TextStyle textStyle,
  required BorderRadius radius,
}) {
  switch (periodDayType) {
    case CalendarPeriodDayType.start:
      (containerColor, textStyle) = sharedPeriodStyling(
        containerColor: containerColor,
        textStyle: textStyle,
      );
      radius = BorderRadius.only(
        topLeft: radiusCircular,
        bottomLeft: radiusCircular,
      );
      break;
    case CalendarPeriodDayType.end:
      (containerColor, textStyle) = sharedPeriodStyling(
        containerColor: containerColor,
        textStyle: textStyle,
      );
      radius = BorderRadius.only(
        topRight: radiusCircular,
        bottomRight: radiusCircular,
      );
      break;
    case CalendarPeriodDayType.single:
      (containerColor, textStyle) = sharedPeriodStyling(
        containerColor: containerColor,
        textStyle: textStyle,
      );
      radius = BorderRadius.all(radiusCircular);
      break;
    case CalendarPeriodDayType.middle:
      (containerColor, textStyle) = sharedPeriodStyling(
        containerColor: containerColor,
        textStyle: textStyle,
      );
      break;
    case CalendarPeriodDayType.none:
      break;
  }
  return (containerColor, textStyle, radius);
}

(Color?, LinearGradient?, TextStyle, BorderRadius) applyDayStyling({
  required CalendarDayType dayType,
  required Color? containerColor,
  required LinearGradient? containerGradient,
  required TextStyle textStyle,
  required BorderRadius radius,
}) {
  TextStyle updatedTextStyle = textStyle;
  switch (dayType) {
    case CalendarDayType.selected:
      if (containerColor != null) {
        containerColor = primary[500]!;
        break;
      }

      containerGradient = LinearGradient(
        colors: [primary[400]!, primary[500]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      radius = BorderRadius.all(radiusCircular * 2);
      updatedTextStyle = textStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
      containerColor = null;
      break;
    case CalendarDayType.today:
      if (containerColor != null) {
        containerColor = primary[300]!;
        break;
      }

      containerGradient = LinearGradient(
        colors: [primary[200]!, primary[300]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      radius = BorderRadius.all(radiusCircular * 2);
      updatedTextStyle = textStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );
      if (containerColor == Colors.transparent) {
        radius = BorderRadius.all(radiusCircular * 2);
      }
      break;
    case CalendarDayType.normal:
      break;
  }
  return (containerColor, containerGradient, updatedTextStyle, radius);
}

class CalendarDayStyle {
  factory CalendarDayStyle({
    required CalendarPeriodDayType periodDayType,
    required CalendarDayType dayType,
  }) {
    Color? containerColor = null;
    LinearGradient? containerGradient = null;
    TextStyle textStyle = TextStyle(color: neutral[900]);
    BorderRadius radius = BorderRadius.zero;

    (containerColor, textStyle, radius) = applyPeriodStyling(
      periodDayType: periodDayType,
      containerColor: containerColor,
      textStyle: textStyle,
      radius: radius,
    );
    (containerColor, containerGradient, textStyle, radius) = applyDayStyling(
      dayType: dayType,
      containerColor: containerColor,
      containerGradient: containerGradient,
      textStyle: textStyle,
      radius: radius,
    );

    return CalendarDayStyle._(
      containerColor: containerColor,
      containerGradient: containerGradient,
      textStyle: textStyle,
      borderRadius: radius,
    );
  }

  CalendarDayStyle._({
    required this.containerColor,
    required this.containerGradient,
    required this.textStyle,
    required this.borderRadius,
  });

  final Color? containerColor;
  // containerGradient takes priority over containerColor.
  final Gradient? containerGradient;
  final TextStyle textStyle;
  final BorderRadius borderRadius;
}
