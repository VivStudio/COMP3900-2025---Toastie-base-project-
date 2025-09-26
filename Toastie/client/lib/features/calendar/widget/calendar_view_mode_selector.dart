import 'package:flutter/material.dart';
import 'package:toastie/features/calendar/models/calendar_view_modes.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

class CalendarViewModeSelector extends StatefulWidget {
  CalendarViewModeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final CalendarViewMode value;
  final ValueChanged<CalendarViewMode> onChanged;

  @override
  State<CalendarViewModeSelector> createState() =>
      _CalendarViewModeSelectorState();
}

class _CalendarViewModeSelectorState extends State<CalendarViewModeSelector> {
  late CalendarViewMode _selectedViewMode;

  @override
  void initState() {
    super.initState();
    _selectedViewMode = widget.value;
  }

  @override
  void didUpdateWidget(CalendarViewModeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _selectedViewMode = widget.value;
      });
    }
  }

  Icon _getIconForMode(CalendarViewMode mode) {
    switch (mode) {
      case CalendarViewMode.timeline:
        return Icon(
          Icons.view_list_sharp,
          size: gridbaseline * 2.5,
          color: primary[600],
        );
      case CalendarViewMode.month:
        return Icon(
          Icons.calendar_view_month,
          size: gridbaseline * 2.5,
          color: primary[600],
        );
      case CalendarViewMode.year:
        return Icon(
          Icons.calendar_today,
          size: gridbaseline * 2.5,
          color: primary[600],
        );
    }
  }

  String _getLabelForMode(CalendarViewMode mode) {
    switch (mode) {
      case CalendarViewMode.timeline:
        return 'Timeline';
      case CalendarViewMode.month:
        return 'Month';
      case CalendarViewMode.year:
        return 'Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: primary[200]!,
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: gridbaseline * 1.5,
            vertical: gridbaseline / 2,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CalendarViewMode>(
              isDense: true,
              value: _selectedViewMode,
              borderRadius: borderRadius,
              dropdownColor: primary[200],
              elevation: 0,
              icon: SizedBox.shrink(), // Hides default dropdown arrow
              items: CalendarViewMode.values.map((mode) {
                return DropdownMenuItem<CalendarViewMode>(
                  value: mode,
                  child: Row(
                    children: [
                      _getIconForMode(mode),
                      SizedBox(width: gridbaseline),
                      Text(
                        _getLabelForMode(mode),
                        style: labelLargeTextWithColor(
                          context,
                          primary[700]!,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (CalendarViewMode? newMode) {
                if (newMode != null) {
                  setState(() {
                    _selectedViewMode = newMode;
                  });
                  widget.onChanged.call(newMode);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
