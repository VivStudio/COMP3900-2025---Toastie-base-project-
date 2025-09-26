import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/period_logs_entity.dart';
import 'package:toastie/services/services.dart';

class PeriodLogsRepository {
  PeriodLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _tableName = 'period_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;
  final int invalidPeriodId = -1;

  Future<PeriodLogsEntity?> getPeriodDetailsForDay({
    required int startOfDayUnix,
    required int endOfDayUnix,
  }) async {
    PeriodLogsEntity? periodLog = null;
    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfDayUnix)
        .lte('date_time', endOfDayUnix)
        .limit(1);
    if (response.length >= 1) {
      periodLog = PeriodLogsEntity.fromJson(response.first);
    }
    return periodLog;
  }

  Future<int> getMaxPeriodId() async {
    int periodId = invalidPeriodId;
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .order('period_id', ascending: false)
        .limit(1)
        .maybeSingle()
        .then((response) {
      PeriodLogsEntity entity = PeriodLogsEntity.fromJson(response);
      periodId = entity.period_id!;
    });
    return periodId;
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsWithPeriodId({
    required int periodId,
  }) async {
    List<PeriodLogsEntity?> periodLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .eq('period_id', periodId)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        PeriodLogsEntity entity = PeriodLogsEntity.fromJson(element);
        periodLogs.add(entity);
      });
    });
    return periodLogs;
  }

  Future<PeriodLogsEntity?> getLastPeriodDateByPeriodId({
    required int periodId,
  }) async {
    PeriodLogsEntity? entity = null;
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .eq('period_id', periodId)
        .order('date_time', ascending: false)
        .limit(1)
        .maybeSingle()
        .then((response) {
      PeriodLogsEntity.fromJson(response);
      entity = PeriodLogsEntity.fromJson(response);
    });
    return entity;
  }

  Future<List<PeriodLogsEntity?>> getPeriodDetailsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<PeriodLogsEntity?> periodLogs = [];

    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        PeriodLogsEntity entity = PeriodLogsEntity.fromJson(element);
        periodLogs.add(entity);
      });
    });

    return periodLogs;
  }

  Future<List<PeriodLogsEntity>> getPeriodByLogIds({
    required Set<int> log_ids,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .in_('log_id', log_ids.toList()) as List;
    if (result.length == 0) {
      return [];
    }

    List<PeriodLogsEntity> entities = [];
    result.forEach((entry) => entities.add(PeriodLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<PeriodLogsEntity?> addPeriod({
    required PeriodLogsEntity periodLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(periodLogsEntity.toJson())
        .select();
    if (result == null || result.length == 0) {
      return null;
    }
    return PeriodLogsEntity.fromJson(result.first);
  }

  Future updatePeriodLogWithId({
    required int log_id,
    required PeriodLogsEntity periodLogsEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(periodLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deletePeriodLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllPeriods() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {
  // AuthenticationService authenticationService = AuthenticationService();
  // User? user = await authenticationService.emailLogIn(
  //   email: toastieEmail,
  //   password: toastiePassword,
  // );

  // if (user != null) {
  //   PeriodLogsRepository periodLogsRepository = PeriodLogsRepository();
  // }
}
