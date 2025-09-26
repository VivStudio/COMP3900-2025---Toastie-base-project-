import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Convert DateTime to UNIX dateTime
int convertToUnixDateTime(DateTime dateTime) {
  return dateTime.millisecondsSinceEpoch ~/ 1000;
}

// Convert UNIX dateTime to DateTime
DateTime convertUnixToDateTime(int unixTimestamp) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
}

// Convert DateTime to time string (eg. 9:00 AM, 9:00 PM)
String formatTime({required DateTime dateTime}) {
  return DateFormat.jm().format(dateTime);
}

// eg. date: 02/09/2025, current time is 2:56pm
// --> returns 02/09/2025 2:56pm
DateTime addCurrentTimeToGivenDate({
  required DateTime date,
}) {
  DateTime now = DateTime.now();
  return DateTime(
    date.year,
    date.month,
    date.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
}

// Create new UNIX dateTime from UNIX dateTime and time String.
int createUnixDateTime({
  required int entityUnixDateTime,
  // In 12-hour time.
  required int hour,
  required int minute,
  required bool isTimeSuffixAM,
}) {
  DateTime date = convertUnixToDateTime(entityUnixDateTime);

  // Hour needs additional logic for handling midnight. We must change midnight to be 0 because otherwise it will think it's midnight of the next day instead.
  if (hour == 12) {
    // If AM, set to 0. Else, keep as 12.
    if (isTimeSuffixAM) {
      hour = 0;
    }
  } else {
    hour = hour + (isTimeSuffixAM ? 0 : 12);
  }

  DateTime dateTime = DateTime(date.year, date.month, date.day, hour, minute);
  return convertToUnixDateTime(dateTime);
}

int convertTimeControllersToUnixDateTime({
  required int originalDateTime,
  required List<bool> selectedTimeSuffix,
  TextEditingController? hourController,
  TextEditingController? minuteController,
}) {
  // If either time controllers are empty, then it was never created which means the user never edited the time.
  if (hourController == null || minuteController == null) {
    return originalDateTime;
  }

  int unixDateTime = createUnixDateTime(
    entityUnixDateTime: originalDateTime,
    hour: int.parse(hourController.text),
    minute: int.parse(minuteController.text),
    isTimeSuffixAM: selectedTimeSuffix[0],
  );
  return unixDateTime;
}

// AM or PM
bool isTimeSuffixAM(String time) {
  List<String> parts = time.split(':');
  int hourInt = int.parse(parts[0]);
  return hourInt < 12;
}

DateTime convertTimeStringToDateTime(DateTime date, String time) {
  // Use the current time if none provided
  if (time.trim().isEmpty) {
    return date;
  }

  if (time.contains(':')) {
    List<String> timeParts = time.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    return DateTime(date.year, date.month, date.day, hours, minutes);
  }
  return date;
}

bool isValidTime(String time) {
  RegExp timeRegex = RegExp(r'^(?:\d|[01]\d|2[0-3]):[0-5]\d$');
  return timeRegex.hasMatch(time);
}

int convertTimeTodayToUnixTimestamp(DateTime date, String time) {
  DateTime dateTime =
      convertTimeStringToDateTime(date, isValidTime(time) ? time : '');

  int unixTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

  return unixTimestamp;
}

String formatMinute({required int minute}) {
  // Prepend 0 if the minute is less than 10.
  // eg. 7:8 -> 7:08
  return minute < 10 ? '0${minute}' : minute.toString();
}

DateTime mergeDateWithCurrentTime(DateTime givenDate) {
  DateTime now = DateTime.now();

  return DateTime(
    givenDate.year,
    givenDate.month,
    givenDate.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
}

String formattedDate({required DateTime dateTime}) {
  return DateFormat('E MMM d').format(dateTime);
}

String formattedDateWithYear({required DateTime dateTime}) {
  return DateFormat('E MMM d, y').format(dateTime);
}

// Eg. March 2025
String formatUnixToMonthYear({required int? unixDateTime}) {
  if (unixDateTime == null) {
    return '';
  }
  return DateFormat('MMMM yyyy').format(convertUnixToDateTime(unixDateTime));
}
