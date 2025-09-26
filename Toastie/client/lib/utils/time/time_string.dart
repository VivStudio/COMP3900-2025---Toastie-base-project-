import 'package:intl/intl.dart';
import 'package:toastie/utils/time/time_utils.dart';

class TimeString {
  TimeString({
    required this.timeIn12HourFormat,
    required this.timeIn24HourFormat,
  });
  final String timeIn12HourFormat;
  final String timeIn24HourFormat;
}

// Convert UNIX dateTime to String
// Rename without convert
TimeString convertUnixDateTimeToTimeString(int unixDateTime) {
  DateTime dateTime = convertUnixToDateTime(unixDateTime);
  return TimeString(
    timeIn12HourFormat: DateFormat('hh:mm').format(dateTime),
    timeIn24HourFormat: DateFormat('HH:mm').format(dateTime),
  );
}
