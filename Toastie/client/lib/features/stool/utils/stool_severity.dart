import 'package:toastie/components/slider.dart';
import 'package:toastie/themes/colors.dart';

final Map<int, SliderDetails> stoolSeverityMap = {
  0: SliderDetails(
    name: 'Type 1',
    description: 'Separate hard lumps (difficult to pass)',
    trackColor: purple,
    iconPath: 'assets/stool/type1.png',
  ),
  1: SliderDetails(
    name: 'Type 2',
    description: 'Sausage-shaped but lumpy',
    trackColor: info,
    iconPath: 'assets/stool/type2.png',
  ),
  2: SliderDetails(
    name: 'Type 3',
    description: 'Sausage with cracks',
    trackColor: success,
    iconPath: 'assets/stool/type3.png',
  ),
  3: SliderDetails(
    name: 'Type 4',
    description: 'Smooth, soft sausage or snake (average)',
    trackColor: accentYellow,
    iconPath: 'assets/stool/type4.png',
  ),
  4: SliderDetails(
    name: 'Type 5',
    description: 'Soft blobs with clear edges',
    trackColor: primary,
    iconPath: 'assets/stool/type5.png',
  ),
  5: SliderDetails(
    name: 'Type 6',
    description: 'Fluffy/ mushy with ragged edges (diarrhea)',
    trackColor: accentPink,
    iconPath: 'assets/stool/type6.png',
  ),
  6: SliderDetails(
    name: 'Type 7',
    description: 'Watery, entirely liquid (diarrhea)',
    trackColor: critical,
    iconPath: 'assets/stool/type7.png',
  ),
};
