import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastie/components/button/icon_button.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text.dart';
import 'package:toastie/utils/grid.dart';

class DayCarousel extends StatefulWidget {
  DayCarousel({
    required this.date,
    required this.fetchData,
  });

  final DateTime date;
  final VoidCallback fetchData;

  final _DayCarouselState state = _DayCarouselState();

  DateTime getDate() {
    return state.getDate();
  }

  @override
  State<DayCarousel> createState() => state;
}

class _DayCarouselState extends State<DayCarousel> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateTime = widget.date;
  }

  DateTime getDate() {
    return _dateTime;
  }

  String _weekday() {
    return DateFormat('EEEE').format(_dateTime).substring(0, 3);
  }

  int _day() {
    return _dateTime.day;
  }

  String _month() {
    return DateFormat('MMMM').format(_dateTime).substring(0, 3);
  }

  void _previousDay() {
    setState(() {
      _dateTime = _dateTime.subtract(Duration(days: 1));
    });
    widget.fetchData();
  }

  void _nextDay() {
    setState(() {
      _dateTime = _dateTime.add(Duration(days: 1));
    });
    widget.fetchData();
  }

  void _goToToday() {
    setState(() {
      _dateTime = DateTime.now();
    });
    widget.fetchData();
  }

  Widget _NavigationButton({
    required IconType iconType,
    required Function() actionHandler,
  }) {
    return Expanded(
      flex: 1,
      child: ToastieIconButton(
        iconType: iconType,
        actionHandler: () => actionHandler(),
        iconButtonType: IconButtonType.FilledButton,
        iconColor: Colors.black,
        fillColor: Colors.transparent,
      ),
    );
  }

  bool _isTextTooLarge(BuildContext context) {
    double textScaleFactor = MediaQuery.of(context).textScaler.textScaleFactor;
    return textScaleFactor > 1.5;
  }

  List<Widget> Content() {
    return [
      Expanded(
        child: Text(
          _weekday(),
          textAlign: TextAlign.left,
          style: titleLargeTextWithColor(
            context: context,
            color: neutral[900]!,
          ).copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      Expanded(
        child: Text(
          _day().toString(),
          textAlign: TextAlign.center,
          style: headlineMediumWithColor(context: context, color: primary)
              .copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      Expanded(
        child: Text(
          _month(),
          textAlign: TextAlign.right,
          style: titleLargeTextWithColor(
            context: context,
            color: neutral[900]!,
          ).copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Row(
          children: [
            _NavigationButton(
              iconType: IconType.NavigateBefore,
              actionHandler: () => _previousDay(),
            ),
            SizedBox(width: gridbaseline * 2),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _goToToday(),
                child: _isTextTooLarge(context)
                    ? Text(
                        '${_weekday()} ${_day()} ${_month()}',
                        textAlign: TextAlign.center,
                        style: titleMediumTextWithColor(
                          context: context,
                          color: neutral[900]!,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: Content(),
                      ),
              ),
            ),
            SizedBox(width: gridbaseline * 2),
            _NavigationButton(
              iconType: IconType.NavigateNext,
              actionHandler: () => _nextDay(),
            ),
          ],
        ),
      ),
    );
  }
}
