import 'package:toastie/components/slider.dart';
import 'package:toastie/themes/colors.dart';

final Map<int, SliderDetails> symptomSeverityMap = {
  0: SliderDetails(
    name: 'Mild',
    trackColor: success,
  ),
  1: SliderDetails(
    name: 'Moderate',
    trackColor: accentYellow,
  ),
  2: SliderDetails(
    name: 'Severe',
    trackColor: primary,
  ),
  3: SliderDetails(
    name: 'Unbearable',
    trackColor: critical,
  ),
};
