import 'package:flutter/services.dart';

enum TimeFormatterType {
  HourFormatter,
  MinuteFormatter,
}

class TimeFormatter extends TextInputFormatter {
  TimeFormatter({
    required this.timeFormatterType,
  });

  final TimeFormatterType timeFormatterType;
  final startTime = 0;
  final maxHours = 12;
  final maxMinutes = 60;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    final int number = int.tryParse(newText)!;

    if (timeFormatterType == TimeFormatterType.HourFormatter &&
        number >= startTime &&
        number <= maxHours) {
      return newValue;
    }

    if (timeFormatterType == TimeFormatterType.MinuteFormatter &&
        number >= startTime &&
        number < maxMinutes) {
      return newValue;
    }

    return oldValue;
  }
}
