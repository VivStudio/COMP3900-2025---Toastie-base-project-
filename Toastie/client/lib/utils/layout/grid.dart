import 'dart:ui';

import 'package:toastie/utils/responsive_utils.dart';

const double gridbaseline = 8.0;

// Used for placeholder + photo images on image upload flows (eg. Magic tracker, meal tracker)
double photoDimensions({required Size size}) {
  return isTabletFromSize(size: size) ? gridbaseline * 25 : gridbaseline * 14;
}

const double graphHeight = gridbaseline * 35;
