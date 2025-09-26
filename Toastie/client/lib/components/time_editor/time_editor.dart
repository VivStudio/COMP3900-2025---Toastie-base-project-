import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastie/components/text_field.dart';
import 'package:toastie/components/time_editor/time_formatter.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';
import 'package:toastie/utils/responsive_utils.dart';
import 'package:toastie/utils/time/time_details.dart';
import 'package:toastie/utils/time/time_utils.dart';

class TimeEditor extends StatefulWidget {
  TimeEditor({
    required super.key,
    required this.details,
    required this.selectedTimeSuffix,
    this.color = primary,
  });

  final TimeDetails details;
  final List<bool> selectedTimeSuffix;
  final MaterialColor color;

  @override
  State<TimeEditor> createState() => TimeEditorState();
}

class TimeEditorState extends State<TimeEditor> {
  // In 12-hour format.
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTime(time: widget.details);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  TextEditingController get hourController => _hourController;

  TextEditingController get minuteController => _minuteController;

  int get hour => int.parse(_hourController.text);

  int get minute => int.parse(_minuteController.text);

  void setTime({required TimeDetails time}) {
    _hourController.text = time.hour.toString();
    _minuteController.text = formatMinute(minute: time.minute);
  }

  void _toggleClicked(int index) {
    setState(() {
      for (int i = 0; i < widget.selectedTimeSuffix.length; i++) {
        widget.selectedTimeSuffix[i] = i == index;
      }
    });
  }

  Widget StackedContents({required MaterialColor textFieldColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ToastieTextFieldWithController(
                controller: _hourController,
                floatingLabel: 'Hour',
                hintText: 'Hour',
                inputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  TimeFormatter(
                    timeFormatterType: TimeFormatterType.HourFormatter,
                  ),
                ],
                color: textFieldColor,
              ),
            ),
            SizedBox(width: gridbaseline),
            // TODO: fix text alignment - slightly off center
            Text(
              ':',
              textAlign: TextAlign.center,
              style: titleMediumTextWithColor(
                context: context,
                color: widget.color[900]!,
              ),
            ),
            SizedBox(width: gridbaseline),
            Expanded(
              child: ToastieTextFieldWithController(
                controller: _minuteController,
                floatingLabel: 'Min',
                hintText: 'Minute',
                inputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  TimeFormatter(
                    timeFormatterType: TimeFormatterType.MinuteFormatter,
                  ),
                ],
                color: textFieldColor,
              ),
            ),
          ],
        ),
        ToggleButtons(
          direction: Axis.vertical,
          onPressed: _toggleClicked,
          borderRadius: BorderRadius.all(Radius.circular(gridbaseline)),
          selectedBorderColor: textFieldColor[500],
          selectedColor: textFieldColor[500],
          fillColor: textFieldColor[200],
          color: textFieldColor[500],
          constraints: BoxConstraints(
            minWidth: gridbaseline * 100,
          ),
          isSelected: widget.selectedTimeSuffix,
          children: [
            Text(
              'AM',
              style: titleMediumTextWithColor(
                context: context,
                color: widget.color[600] as Color,
              ),
            ),
            Text(
              'PM',
              style: titleMediumTextWithColor(
                context: context,
                color: widget.color[600] as Color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget DefaultContents({required MaterialColor textFieldColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ToastieTextFieldWithController(
            controller: _hourController,
            floatingLabel: 'Hour',
            hintText: 'Hour',
            inputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
              TimeFormatter(
                timeFormatterType: TimeFormatterType.HourFormatter,
              ),
            ],
            color: textFieldColor,
          ),
        ),
        SizedBox(width: gridbaseline),
        // TODO: fix text alignment - slightly off center
        Text(
          ':',
          textAlign: TextAlign.center,
          style: titleMediumTextWithColor(
            context: context,
            color: widget.color[900]!,
          ),
        ),
        SizedBox(width: gridbaseline),
        Expanded(
          child: ToastieTextFieldWithController(
            controller: _minuteController,
            floatingLabel: 'Min',
            hintText: 'Minute',
            inputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
              TimeFormatter(
                timeFormatterType: TimeFormatterType.MinuteFormatter,
              ),
            ],
            color: textFieldColor,
          ),
        ),
        SizedBox(width: gridbaseline * 2),
        ToggleButtons(
          direction: Axis.vertical,
          onPressed: _toggleClicked,
          borderRadius: BorderRadius.all(Radius.circular(gridbaseline)),
          selectedBorderColor: textFieldColor[500],
          selectedColor: textFieldColor[500],
          fillColor: textFieldColor[200],
          color: textFieldColor[500],
          constraints: BoxConstraints(
            minWidth: gridbaseline * 6,
          ),
          isSelected: widget.selectedTimeSuffix,
          children: [
            Text(
              'AM',
              style: titleMediumTextWithColor(
                context: context,
                color: widget.color[600] as Color,
              ),
            ),
            Text(
              'PM',
              style: titleMediumTextWithColor(
                context: context,
                color: widget.color[600] as Color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MaterialColor textFieldColor = widget.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shouldAdaptForAccessibility(context: context)
            ? StackedContents(textFieldColor: textFieldColor)
            : DefaultContents(textFieldColor: textFieldColor),
      ],
    );
  }
}
