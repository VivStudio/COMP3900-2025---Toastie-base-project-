import 'package:flutter/material.dart';
import 'package:toastie/utils/layout/grid.dart';

const Radius radiusCircular = Radius.circular(gridbaseline * 2);

const BorderRadius borderRadiusSmall =
    BorderRadius.all(Radius.circular(gridbaseline));
const BorderRadius borderRadius = BorderRadius.all(radiusCircular);

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

const BorderRadius dropDownBorderRadius =
    BorderRadius.all(Radius.circular(gridbaseline * 2));
