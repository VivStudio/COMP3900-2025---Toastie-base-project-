import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/repositories/trackers/weight_logs_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/time_utils.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class WeightLogsService {
  WeightLogsService() {}

  Future<WeightLogsEntity?> getWeightForDay({required DateTime date}) async {
    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<WeightLogsRepository>().getWeightForDay(
      startOfDayUnix: unixTime.startTime,
      endOfDayUnix: unixTime.endTime,
    );
  }

  Future<List<WeightLogsEntity?>?> getWeightDetailsForDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDateRangeToUnixDateRange(
      startDate: startDate,
      endDate: endDate,
    );
    return locator<WeightLogsRepository>().getWeightsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<WeightLogsEntity?>?> getWeightsForWeek({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertToUnixWeekRange(date);
    return locator<WeightLogsRepository>().getWeightsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<WeightLogsEntity?>?> getWeightBetweenTwoDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<WeightLogsRepository>().getWeightsForRange(
      startOfUnix: convertToUnixDateTime(startDate),
      endOfUnix: convertToUnixDateTime(endDate),
    );
  }

  Future<List<WeightLogsEntity>> getWeightByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<WeightLogsRepository>().getWeightByIds(
      log_ids: log_ids,
    );
  }

  Future addWeight({
    required int unixDateTime,
    required double weight,
  }) async {
    await locator<WeightLogsRepository>().addWeight(
      weightLogsEntity: WeightLogsEntity(
        user_id: locator<SupabaseClient>().auth.currentUser!.id,
        date_time: unixDateTime,
        weight: weight,
      ),
    );
  }

  Future updateWeightLogWithId({
    required int log_id,
    int? unixDateTime,
    double? weight,
  }) async {
    if (!shouldRunRpc) {
      return null;
    }

    WeightLogsEntity entity = WeightLogsEntity();
    entity.date_time ??= unixDateTime;
    entity.weight ??= weight;

    await locator<WeightLogsRepository>().updateWeightLogWithId(
      log_id: log_id,
      weightLogsEntity: entity,
    );
  }

  deleteWeightLogWithId({required int log_id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<WeightLogsRepository>().deleteWeightLogWithId(log_id: log_id);
  }

  deleteAllWeights() {
    if (!shouldRunRpc) {
      return;
    }

    locator<WeightLogsRepository>().deleteAllWeights();
  }
}
