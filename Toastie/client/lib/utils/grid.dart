import 'package:flutter/material.dart';

const double gridbaseline = 8.0;

const none = 0.0;

const Radius radiusCircular = Radius.circular(gridbaseline * 2);
const Radius radiusCircularLarge = Radius.circular(gridbaseline * 5);

const BorderRadius borderRadius = BorderRadius.all(radiusCircular);
const BorderRadius borderRadiusCircular = BorderRadius.all(radiusCircularLarge);

const BorderRadius leftBorderRadius = BorderRadius.only(
  topLeft: radiusCircular,
  bottomLeft: radiusCircular,
);
const BorderRadius rightBorderRadius = BorderRadius.only(
  topRight: radiusCircular,
  bottomRight: radiusCircular,
);

const BorderRadius topBorderRadius = BorderRadius.only(
  topLeft: radiusCircular,
  topRight: radiusCircular,
);

const BorderRadius leftBorderCircleRadius = BorderRadius.only(
  topLeft: radiusCircularLarge,
  bottomLeft: radiusCircularLarge,
);
const BorderRadius rightBorderCircleRadius = BorderRadius.only(
  topRight: radiusCircularLarge,
  bottomRight: radiusCircularLarge,
);

const RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: borderRadius,
);

const int textMinLines = 1;
const int textMinMultilines = 10;
const int notesTrackerTextMinMultilines = 20;

double authenticationLogoSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.15;
}

double trackerHeaderImageSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.5;
}

double fillerImageSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.2;
}

double searchResultsScrollableContentSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.5;
}

double itemNotFoundImageSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.15;
}

double headerSmallImageSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.2;
}

double headerImageSize(BuildContext context) {
  return MediaQuery.sizeOf(context).height * 0.3;
}

Size buttonWidth(BuildContext context, bool fullWidth) {
  double width = fullWidth ? 1 : 0.7;
  return Size(MediaQuery.sizeOf(context).width * width, gridbaseline * 6);
}
