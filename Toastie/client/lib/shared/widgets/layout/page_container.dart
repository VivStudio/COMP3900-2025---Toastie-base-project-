import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/gradient_background_colors.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';

enum PageSizeType {
  // Used for authentication flows.
  Narrow,
  Standard,
}

class PageContainer extends StatelessWidget {
  PageContainer({
    required this.childInFactionallySizedBox,
    this.childOutsideFactionallySizedBox = const SizedBox.shrink(),
    BoxDecoration? color,
    this.sizeType = PageSizeType.Standard,
    this.image,
    this.imageRatio,
  }) : color = color ?? primaryLighterGradientBackground;

  final Widget childInFactionallySizedBox;
  final Widget childOutsideFactionallySizedBox;
  final BoxDecoration color;
  final PageSizeType? sizeType;
  final String? image;
  final double? imageRatio;

  double _widthFactory({required BuildContext context}) {
    final tablet = isTablet(context: context);

    if (sizeType == PageSizeType.Standard) {
      return tablet ? 0.75 : 0.85;
    } else {
      return tablet ? 0.6 : 0.7;
    }
  }

  Widget PageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (image != null)
          Container(
            color: accentPink[200],
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: AssetImage(image!),
              height: imageRatio ?? trackerHeaderImageSize(context),
              fit: BoxFit.fitHeight,
            ),
          ),
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            decoration: (image != null) ? color : null,
            child: FractionallySizedBox(
              widthFactor: _widthFactory(context: context),
              child: childInFactionallySizedBox,
            ),
          ),
        ),
        childOutsideFactionallySizedBox,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: PageContent(context),
        ),
      );
    }

    return GestureDetector(
      // Dismiss the keyboard when the user taps on any area of the screen not covered by other components.
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: color,
          child: SafeArea(
            child: PageContent(context),
          ),
        ),
      ),
    );
  }
}
