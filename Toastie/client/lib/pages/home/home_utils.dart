import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/utils/utils.dart';

String getListSummary<T>(
  List<T>? list,
) {
  if (list == null || list.length == 0) return '';
  Set<T>? set = list.toSet();
  return capitalizeFirstCharacter(set.join(', '));
}

String getStoolSummary(List<StoolLogsEntity?>? stools) {
  if (stools == null || stools.isEmpty) return '';
  return '${stools.length} bowel movement${stools.length > 1 ? 's' : ''}';
}

String getPeriodSummary(PeriodLogsEntity? period) {
  if (period == null) return '';
  // Changing this return value could cause breaking changes on the period manual tracker flow.
  // The manual tracker flow sets the slider based on the period summary (parse by cutting ' flow'). We would like to change this in the future, when the slider is redesigned.
  return capitalizeFirstCharacter('${period.severity?.jsonValue} flow');
}

String getWeightSummary(WeightLogsEntity? weight) {
  if (weight == null) return '';
  return '${weight.weight}kg';
}

String getNoteSummary(NoteLogsEntity? notes) {
  return notes?.note?.trim() ?? '';
}

double? stripUnitFromWeight(String input) {
  RegExp regExp = RegExp(r'[-+]?\d*\.?\d+');
  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return double.tryParse(match.group(0)!);
  }
  return null;
}
