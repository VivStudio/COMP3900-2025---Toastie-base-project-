import 'package:flutter/material.dart';
import 'package:toastie/features/calendar/models/calendar_view_modes.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/time/time_utils.dart';

String viewModeToString(CalendarViewMode viewMode) {
  switch (viewMode) {
    case CalendarViewMode.month:
      return 'Calendar';
    case CalendarViewMode.timeline:
      return 'Timeline';
    case CalendarViewMode.year:
      return 'Calendar';
  }
}

Border? leftBorder = Border(
  top: BorderSide(color: accentPink[300]!, width: 1),
  bottom: BorderSide(color: accentPink[300]!, width: 1),
  left: BorderSide(color: accentPink[300]!, width: 1),
);

Border? rightBorder = Border(
  top: BorderSide(color: accentPink[300]!, width: 1),
  bottom: BorderSide(color: accentPink[300]!, width: 1),
  right: BorderSide(color: accentPink[300]!, width: 1),
);

Border? middleBorder = Border(
  top: BorderSide(color: accentPink[300]!, width: 1),
  bottom: BorderSide(color: accentPink[300]!, width: 1),
);

double textScaleFactor(BuildContext context) {
  return MediaQuery.of(context).textScaler.textScaleFactor;
}

bool isTextTooLarge(BuildContext context) {
  return textScaleFactor(context) > 1.7;
}

final isSameDay = (DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isTracked(Set<DateTime> trackedDates, DateTime date) {
  return trackedDates.any(
    (trackedDate) =>
        trackedDate.year == date.year &&
        trackedDate.month == date.month &&
        trackedDate.day == date.day,
  );
}

bool isRangeStart(DateTime date, DateTimeRange highlightedRange) =>
    isSameDay(date, highlightedRange.start);

bool isRangeEnd(
  DateTime date,
  DateTimeRange highlightedRange,
) =>
    isSameDay(date, highlightedRange.end);

bool isRangeMiddle(
  DateTime date,
  DateTimeRange highlightedRange,
  DateTime focusedDate,
) =>
    isInRange(date, highlightedRange, focusedDate) &&
    !isRangeStart(date, highlightedRange) &&
    !isRangeEnd(date, highlightedRange);

bool isInRange(
  DateTime day,
  DateTimeRange highlightedRange,
  DateTime focusedDate,
) {
  return !day.isBefore(highlightedRange.start) &&
      !day.isAfter(highlightedRange.end) &&
      day.month == focusedDate.month;
}

List<DateTimeRange> getPeriodDateRanges(List<dynamic> periodEntries) {
  // Group period entries by consecutive days and create highlighted ranges
  List<DateTimeRange> ranges = [];
  if (periodEntries.isNotEmpty) {
    // Convert all period entries to DateTime and sort
    List<DateTime> periodDates = periodEntries
        .map((entry) => convertUnixToDateTime(entry.date_time))
        .whereType<DateTime>()
        .toList()
      ..sort();

    if (periodDates.isNotEmpty) {
      DateTime? rangeStart = DateTime(
        periodDates.first.year,
        periodDates.first.month,
        periodDates.first.day,
      );
      DateTime? prevDate = periodDates.first;

      for (int i = 1; i < periodDates.length; i++) {
        final current = periodDates[i];
        // If current date is not consecutive to previous, close the current range
        if (current.difference(prevDate!).inDays > 1) {
          final normalizedEnd =
              DateTime(prevDate.year, prevDate.month, prevDate.day);
          ranges.add(DateTimeRange(start: rangeStart!, end: normalizedEnd));
          rangeStart = DateTime(current.year, current.month, current.day);
        }
        prevDate = current;
      }
      // Add the last range
      if (rangeStart != null && prevDate != null) {
        final normalizedEnd =
            DateTime(prevDate.year, prevDate.month, prevDate.day);
        ranges.add(DateTimeRange(start: rangeStart, end: normalizedEnd));
      }
    }
  }

  return ranges;
}
