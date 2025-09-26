import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/repositories/trackers/period_logs_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/time_utils.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class PeriodLogsService {
  PeriodLogsService() {}

  final int invalidPeriodId = -1;

  Future<PeriodLogsEntity?> getPeriodDetailsForDay({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return null;
    }
    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<PeriodLogsRepository>().getPeriodDetailsForDay(
      startOfDayUnix: unixTime.startTime,
      endOfDayUnix: unixTime.endTime,
    );
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsForDateRange({
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
    return locator<PeriodLogsRepository>().getPeriodDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsForWeek({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }
    UnixDateRange unixTime = convertToUnixWeekRange(date);
    return locator<PeriodLogsRepository>().getPeriodDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsForMonth({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }
    UnixDateRange unixTime = convertToUnixMonthRange(date);
    return locator<PeriodLogsRepository>().getPeriodDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<int> getMaxPeriodId() async {
    if (!shouldRunRpc) {
      return invalidPeriodId;
    }
    return locator<PeriodLogsRepository>().getMaxPeriodId();
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsWithPeriodId({
    required int periodId,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }
    return locator<PeriodLogsRepository>().getPeriodDetailsWithPeriodId(
      periodId: periodId,
    );
  }

  Future<PeriodLogsEntity?> getLastPeriodDateByPeriodId({
    required int periodId,
  }) async {
    if (!shouldRunRpc) {
      return null;
    }
    return locator<PeriodLogsRepository>().getLastPeriodDateByPeriodId(
      periodId: periodId,
    );
  }

  Future<List<PeriodLogsEntity>> getPeriodByLogIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<PeriodLogsRepository>().getPeriodByLogIds(
      log_ids: log_ids,
    );
  }

  /**
   * Add new period entry and autofill any missing days.
   * 
   * If a period was logged within 5 days of the given date, use its period_id to:
   * - Fill in missing days with medium flow (no need to await)
   * - Log the given day's period
   * If no period was logged in the last 5 days, assign the given day a new period_id by incrementing the highest existing one.
   */
  Future addPeriod({
    required int unixDateTime,
    required PeriodFlow severity,
  }) async {
    // Get date 5 days before the given date.
    DateTime dateTime = convertUnixToDateTime(unixDateTime);
    UnixDateRange dateTimeRange = convertDayToUnixDateRange(date: dateTime);

    DateTime fiveDaysAgo = convertUnixToDateTime(dateTimeRange.startTime)
        .subtract(Duration(days: 5));
    UnixDateRange fiveDaysAgoUnixDateTimeRange =
        convertDayToUnixDateRange(date: fiveDaysAgo);

    // Get all period logs in the last 5 days
    List<PeriodLogsEntity?> lastFiveDaysLogs =
        await locator<PeriodLogsRepository>().getPeriodDetailsForRange(
      startOfUnix: fiveDaysAgoUnixDateTimeRange.startTime,
      endOfUnix: unixDateTime,
    );

    int periodId = invalidPeriodId;
    if (lastFiveDaysLogs.isNotEmpty) {
      // Get periodId based on recent Periods.
      periodId = lastFiveDaysLogs.last!.period_id!;

      // Autofill periods for any missing days.
      _autoFillMissingPeriodLogs(
        startDay: fiveDaysAgo,
        endDay: dateTime.subtract(
          Duration(days: 1),
        ), // Set end day to yesterday to prevent duplicate logs from today.
        logs: lastFiveDaysLogs,
      );
    } else {
      // Add the new period log with incremented period_id
      periodId = await locator<PeriodLogsRepository>().getMaxPeriodId() + 1;
    }

    await _addPeriodWithoutAutoFill(
      period: PeriodLogsEntity(
        user_id: locator<SupabaseClient>().auth.currentUser!.id,
        date_time: unixDateTime,
        severity: severity,
        period_id: periodId,
      ),
    );
  }

  void _autoFillMissingPeriodLogs({
    required DateTime startDay,
    required DateTime endDay,
    required List<PeriodLogsEntity?> logs,
  }) async {
    if (logs.isEmpty) {
      return;
    }

    // Get the period_id from the last log (most recent)
    int periodId = logs.last?.period_id ?? invalidPeriodId;

    // Create a set of dates that already have logs for efficient lookup
    Set<DateTime> existingDates = logs.map((log) {
      DateTime date = convertUnixToDateTime(log!.date_time!);
      return DateTime(date.year, date.month, date.day);
    }).toSet();

    // Start from startDay and check each day until endDay
    DateTime currentDate = startDay;
    while (!currentDate.isAfter(endDay)) {
      DateTime normalizedDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      // If no log exists for this date, add a medium flow entry (do not wait for this).
      if (!existingDates.contains(normalizedDate)) {
        _addPeriodWithoutAutoFill(
          period: PeriodLogsEntity(
            user_id: locator<SupabaseClient>().auth.currentUser!.id,
            date_time: convertToUnixDateTime(currentDate),
            severity: PeriodFlow.medium,
            period_id: periodId,
          ),
        );
      }

      currentDate = currentDate.add(Duration(days: 1));
    }
  }

  Future _addPeriodWithoutAutoFill({required PeriodLogsEntity period}) async {
    await locator<PeriodLogsRepository>().addPeriod(
      periodLogsEntity: period,
    );
  }

  Future updatePeriodLogWithId({
    required int log_id,
    DateTime? dateTime,
    PeriodFlow? severity,
  }) async {
    if (!shouldRunRpc) {
      return null;
    }

    PeriodLogsEntity entity = PeriodLogsEntity();
    if (dateTime != null) {
      entity.date_time = convertToUnixDateTime(dateTime);
    }
    entity.severity ??= severity;

    await locator<PeriodLogsRepository>().updatePeriodLogWithId(
      log_id: log_id,
      periodLogsEntity: entity,
    );
  }

  Future deletePeriodLogWithId({required int log_id}) async {
    if (!shouldRunRpc) {
      return;
    }

    await locator<PeriodLogsRepository>().deletePeriodLogWithId(log_id: log_id);
  }

  deleteAllPeriods() {
    if (!shouldRunRpc) {
      return;
    }

    locator<PeriodLogsRepository>().deleteAllPeriods();
  }
}
