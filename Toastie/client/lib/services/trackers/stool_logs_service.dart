import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/repositories/trackers/stool_logs_repository.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class StoolLogsService {
  StoolLogsService() {}

  Future<List<StoolLogsEntity?>?> getStoolDetailsForDay({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<StoolLogsRepository>().getStoolDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<StoolLogsEntity?>?> getStoolDetailsForDateRange({
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
    return locator<StoolLogsRepository>().getStoolDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<StoolLogsEntity?>?> getStoolDetailsForWeek({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertToUnixWeekRange(date);
    return locator<StoolLogsRepository>().getStoolDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<StoolLogsEntity>> getStoolByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<StoolLogsRepository>().getStoolByIds(
      log_ids: log_ids,
    );
  }

  Future addStool({
    required int unixDateTime,
    required BristolScale severity,
  }) async {
    await locator<StoolLogsRepository>().addStool(
      stoolLogsEntity: StoolLogsEntity(
        user_id: locator<SupabaseClient>().auth.currentUser!.id,
        date_time: unixDateTime,
        severity: severity,
      ),
    );
  }

  updateStoolLogWithId({
    required int log_id,
    int? unixDateTime,
    BristolScale? severity,
  }) {
    if (!shouldRunRpc) {
      return;
    }

    StoolLogsEntity entity = StoolLogsEntity();
    entity.date_time ??= unixDateTime;
    entity.severity ??= severity;

    locator<StoolLogsRepository>().updateStoolLogWithId(
      log_id: log_id,
      stoolLogsEntity: entity,
    );
  }

  deleteStoolLogWithId({required int log_id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<StoolLogsRepository>().deleteStoolLogWithId(log_id: log_id);
  }

  deleteAllStools() {
    if (!shouldRunRpc) {
      return;
    }

    locator<StoolLogsRepository>().deleteAllStools();
  }
}

void main() async {
  AuthenticationService authenticationService = AuthenticationService();
  User? user = await authenticationService.emailLogIn(
    email: toastieEmail,
    password: toastiePassword,
  );
  if (user != null) {}
}
