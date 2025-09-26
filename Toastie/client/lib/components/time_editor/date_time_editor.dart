import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

// Date formating
const Map<CupertinoDatePickerMode, String> _dateFormatMap = {
  CupertinoDatePickerMode.date: 'MMM d y',
  CupertinoDatePickerMode.time: 'h:mm a',
  CupertinoDatePickerMode.dateAndTime: 'd MMM y h:mm a',
};

// Widget size
const Map<CupertinoDatePickerMode, int> _widgetSize = {
  CupertinoDatePickerMode.date: 30,
  CupertinoDatePickerMode.time: 20,
  CupertinoDatePickerMode.dateAndTime: 30,
};

class DateTimeEditor extends StatelessWidget {
  DateTimeEditor({
    required this.dateTime,
    required this.pickerMode,
    required this.showEditor,
    required this.onDateTimeChange,
    required this.onDateTimeChanged,
    required this.color,
  });

  final DateTime dateTime;
  final CupertinoDatePickerMode pickerMode;
  final bool showEditor;
  final Function() onDateTimeChange;
  final Function(DateTime date) onDateTimeChanged;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gridbaseline),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color[100],
          border: Border.all(
            color: showEditor ? color[500] as Color : color[300] as Color,
          ),
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gridbaseline * 2),
              child: ListTile(
                trailing: Icon(
                  Icons.calendar_month,
                  color: color as Color,
                  size: smallIconSize,
                ),
                title: Text(
                  DateFormat(_dateFormatMap[pickerMode]!).format(dateTime),
                  style: titleMediumTextWithColor(
                    context: context,
                    color: color[900] as Color,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.comfortable,
                onTap: () => onDateTimeChange(),
              ),
            ),
            Visibility(
              visible: showEditor,
              child: SizedBox(
                height: gridbaseline * _widgetSize[pickerMode]!,
                child: CupertinoDatePicker(
                  initialDateTime: dateTime,
                  mode: pickerMode,
                  onDateTimeChanged: (DateTime date) => onDateTimeChanged(date),
                  maximumDate: pickerMode == CupertinoDatePickerMode.time
                      ? null
                      : DateTime.now(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
