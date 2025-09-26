import 'package:intl/intl.dart';

String formatDate(int? timestamp) {
  if (timestamp == null) {
    return '';
  }
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  String day = date.day.toString();
  String suffix;
  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  String monthYear = DateFormat('MMM').format(date);
  String year = DateFormat('y').format(date);
  return '$day$suffix $monthYear $year';
}
