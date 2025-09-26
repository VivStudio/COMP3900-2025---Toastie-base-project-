import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

enum SliderStyle {
  card,
  period,
  stool,
}

class SliderDetails {
  SliderDetails({
    required this.name,
    this.description = '',
    this.trackColor = primary,
    this.iconPath,
  });

  String name;
  String description;
  MaterialColor trackColor;
  String? iconPath;
}

class ToastieSlider extends StatefulWidget {
  ToastieSlider({
    required this.severityMap,
    required this.style,
    super.key,
    this.title = '',
    this.showDescription = false,
    this.updateCardColor = emptyFunction,
    this.updateSliderValue = emptyFunctionDouble,
    this.padding = 0,
    this.sliderValue = 1,
  });

  final Map<int, SliderDetails> severityMap;
  final String title;
  /** Title description. */
  final bool showDescription;
  final SliderStyle style;
  static void emptyFunction(MaterialColor color) {}
  static void emptyFunctionDouble(double value) {}
  final Function(MaterialColor color) updateCardColor;
  final Function(double value) updateSliderValue;
  final double padding;
  final double sliderValue;

  final _ToastieSliderState toastieSliderState = _ToastieSliderState();

  double currentSliderValue() {
    return toastieSliderState.currentSliderValue;
  }

  @override
  State<ToastieSlider> createState() => toastieSliderState;
}

// TODO: change to stateless widget - update value from parent
class _ToastieSliderState extends State<ToastieSlider> {
  double currentSliderValue = 1.0;

  @override
  void initState() {
    super.initState();
    currentSliderValue = widget.sliderValue;
  }

  void updateSliderValue(double value) {
    // Instead of this, I should tell the parent widget to set the slider value to value?
    setState(() {
      currentSliderValue = value;
    });

    // MaterialColor color = widget.severityMap[currentSliderValue]!.trackColor;
    // // TODO: fix slider container color change.
    // widget.updateCardColor(color);

    widget.updateSliderValue(value);
  }

  Widget _title(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.severityMap[currentSliderValue]!.iconPath !=
                          null)
                        Image(
                          image: AssetImage(
                            widget.severityMap[currentSliderValue]!.iconPath
                                .toString(),
                          ),
                          width: gridbaseline * 4,
                          fit: BoxFit.fitHeight,
                        ),
                      SizedBox(width: gridbaseline),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.severityMap[currentSliderValue]!.name,
                              style: titleMediumTextWithColor(
                                context: context,
                                color: widget.severityMap[currentSliderValue]!
                                    .trackColor[900]!,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            if (widget.showDescription)
                              Text(
                                '${widget.severityMap[currentSliderValue]!.description}',
                                style: labelMediumTextWithColor(
                                  context,
                                  widget.severityMap[currentSliderValue]!
                                      .trackColor[600]!,
                                ),
                                softWrap: true,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color trackColor = widget.severityMap[currentSliderValue]!.trackColor;

    return Wrap(
      runSpacing: gridbaseline,
      children: [
        _title(context),
        // Slider
        Padding(
          padding: widget.style == SliderStyle.card
              ? EdgeInsets.symmetric(
                  horizontal: widget.padding / 2,
                  vertical: gridbaseline,
                )
              : EdgeInsets.zero,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTickMarkColor: Colors.transparent,
              activeTrackColor: trackColor,
              // TODO: make this Colors.transparent again when we have added state management on the slider.
              inactiveTickMarkColor:
                  widget.severityMap[currentSliderValue]!.trackColor[600],
              inactiveTrackColor:
                  widget.severityMap[currentSliderValue]!.trackColor[200],
              overlayShape: RoundSliderOverlayShape(overlayRadius: none),
              showValueIndicator: ShowValueIndicator.never,
              thumbColor: Colors.white,
              trackHeight: gridbaseline * 2,
              valueIndicatorColor: trackColor,
            ),
            child: Slider(
              divisions: widget.severityMap.length - 1,
              label: widget.severityMap[currentSliderValue]!.name,
              min: 0,
              max: widget.severityMap.length.toDouble() - 1,
              value: currentSliderValue,
              onChanged: updateSliderValue,
            ),
          ),
        ),
      ],
    );
  }
}
