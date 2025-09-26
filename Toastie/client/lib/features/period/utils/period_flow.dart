import 'package:toastie/components/slider.dart';
import 'package:toastie/themes/colors.dart';

final Map<int, SliderDetails> periodFlowMap = {
  0: SliderDetails(
    name: 'Spotting',
    trackColor: success,
    iconPath: 'assets/period/spotting.png',
  ),
  1: SliderDetails(
    name: 'Light',
    trackColor: accentYellow,
    iconPath: 'assets/period/light.png',
  ),
  2: SliderDetails(
    name: 'Medium',
    trackColor: primary,
    iconPath: 'assets/period/medium.png',
  ),
  3: SliderDetails(
    name: 'Heavy',
    trackColor: accentPink,
    iconPath: 'assets/period/heavy.png',
  ),
};
