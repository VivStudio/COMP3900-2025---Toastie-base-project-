import 'package:toastie/utils/time/time_string.dart';
import 'package:toastie/utils/time/time_utils.dart';

class TimeDetails {
  TimeDetails({
    required this.isAm,
    required this.hour,
    required this.minute,
  });

  final bool isAm;
  final int hour;
  final int minute;
}

TimeDetails timeDetailsFromUnixDateTime(int dateTime) {
  String time = convertUnixDateTimeToTimeString(dateTime).timeIn24HourFormat;

  List<String> parts = time.split(':');
  bool isAm = true;
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  // Convert hour from 24-hour to 12-hour format and determine if it's AM or PM.
  if (hour >= 12) {
    isAm = false;
    hour = hour > 12 ? hour - 12 : hour;
  }

  return TimeDetails(
    isAm: isAm,
    hour: hour,
    minute: minute,
  );
}

String stringFromTimeDetails({
  required TimeDetails details,
  required List<bool> selectedTimeSuffix,
}) {
  return '${details.hour}:${formatMinute(minute: details.minute)} ${selectedTimeSuffix[0] ? 'AM' : 'PM'}';
}
