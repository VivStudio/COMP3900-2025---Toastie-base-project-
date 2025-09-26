import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/stool_logs_entity.dart';
import 'package:toastie/services/services.dart';

class StoolLogsRepository {
  StoolLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _tableName = 'stool_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<StoolLogsEntity?>?> getStoolDetailsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<StoolLogsEntity?>? stoolLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        StoolLogsEntity entity = StoolLogsEntity.fromJson(element);
        stoolLogs.add(entity);
      });
    });
    return stoolLogs;
  }

  Future<List<StoolLogsEntity>> getStoolByIds({
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

    List<StoolLogsEntity> entities = [];
    result.forEach((entry) => entities.add(StoolLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<StoolLogsEntity?> addStool({
    required StoolLogsEntity stoolLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(stoolLogsEntity.toJson())
        .select();
    if (result == null || result.length == 0) {
      return null;
    }
    return StoolLogsEntity.fromJson(result.first);
  }

  updateStoolLogWithId({
    required int log_id,
    required StoolLogsEntity stoolLogsEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(stoolLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteStoolLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllStools() async {
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
  //   StoolLogsRepository stoolLogsRepository = StoolLogsRepository();
  // }
}
