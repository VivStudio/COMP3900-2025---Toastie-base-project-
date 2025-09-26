import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class CalendarYearView extends StatelessWidget {
  CalendarYearView({
    required this.year,
    required this.activityByDay,
    this.onDateTap,
    super.key,
  });

  final int year;
  final Map<DateTime, int> activityByDay;
  final void Function(DateTime date)? onDateTap;

  static const int daysInWeek = 7;
  static const double gridSize = gridbaseline * 2.5;

  Color _getColorForCount(int count) {
    if (count == 0) return neutral[200]!;
    if (count == 1) return success[100]!;
    if (count == 2) return success[200]!;
    if (count == 3) return success[300]!;
    if (count == 4) return success[400]!;
    if (count == 5) return success[500]!;
    if (count == 6) return success[600]!;
    if (count == 7) return success[700]!;
    if (count == 8) return success[800]!;
    return success[900]!;
  }

  List<List<DateTime?>> _buildMonths() {
    List<List<DateTime?>> months = [];

    for (int month = 1; month <= 12; month++) {
      // final firstDayOfMonth = DateTime(year, month, 1);
      final daysInMonth = DateTime(year, month + 1, 0).day;
      List<DateTime?> monthDays = List.generate(daysInMonth, (i) {
        return DateTime(year, month, i + 1);
      });

      // Add empty placeholders to align each week starting from Monday
      // int leadingEmptyDays = (firstDayOfMonth.weekday + 6) % 7;
      months.add([
        // ...List.filled(leadingEmptyDays, null),
        ...monthDays,
      ]);
    }

    return months;
  }

  @override
  Widget build(BuildContext context) {
    final months = _buildMonths();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: gridbaseline),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$year',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SizedBox(height: gridbaseline),
          ...List.generate(months.length, (index) {
            final monthName =
                DateFormat.MMM().format(DateTime(year, index + 1));

            return Padding(
              padding: EdgeInsets.symmetric(vertical: gridbaseline / 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: gridbaseline * 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        monthName,
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(width: gridbaseline),
                  Expanded(
                    child: Wrap(
                      spacing: gridbaseline / 2,
                      runSpacing: gridbaseline / 2,
                      children: months[index].map((day) {
                        if (day == null) {
                          return SizedBox(width: gridSize, height: gridSize);
                        }

                        final count = activityByDay[
                                DateTime(day.year, day.month, day.day)] ??
                            0;
                        return GestureDetector(
                          onTap: () {
                            onDateTap?.call(day);
                          },
                          child: Container(
                            width: gridSize,
                            height: gridSize,
                            decoration: BoxDecoration(
                              color: _getColorForCount(count),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
