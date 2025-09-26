import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/weight_logs_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class WeightLogsRepository {
  WeightLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'weight_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<WeightLogsEntity?> getWeightForDay({
    required int startOfDayUnix,
    required int endOfDayUnix,
  }) async {
    WeightLogsEntity? weightLog = null;
    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfDayUnix)
        .lte('date_time', endOfDayUnix)
        .limit(1);
    if (response.length >= 1) {
      weightLog = WeightLogsEntity.fromJson(response.first);
    }
    return weightLog;
  }

  Future<List<WeightLogsEntity?>?> getWeightsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<WeightLogsEntity?>? weightLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        WeightLogsEntity entity = WeightLogsEntity.fromJson(element);
        weightLogs.add(entity);
      });
    });

    return weightLogs;
  }

  Future<List<WeightLogsEntity>> getWeightByIds({
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

    List<WeightLogsEntity> entities = [];
    result.forEach((entry) => entities.add(WeightLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<WeightLogsEntity?> addWeight({
    required WeightLogsEntity weightLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(weightLogsEntity.toJson())
        .select();
    if (result == null || result.length == 0) {
      return null;
    }
    return WeightLogsEntity.fromJson(result.first);
  }

  updateWeightLogWithId({
    required int log_id,
    required WeightLogsEntity weightLogsEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(weightLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteWeightLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllWeights() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
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
