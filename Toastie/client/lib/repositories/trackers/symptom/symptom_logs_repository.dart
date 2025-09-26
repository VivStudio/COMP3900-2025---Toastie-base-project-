import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/symptom/symptom_logs_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class SymptomLogsRepository {
  SymptomLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _tableName = 'symptom_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<SymptomLogsEntity?>?> getSymptomDetailsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<SymptomLogsEntity?>? symptomLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        SymptomLogsEntity entity = SymptomLogsEntity.fromJson(element);
        symptomLogs.add(entity);
      });
    });
    return symptomLogs;
  }

  Future<List<SymptomLogsEntity?>?> getSymptomDetailsForRangeById({
    required int startOfUnix,
    required int endOfUnix,
    required int id,
  }) async {
    List<SymptomLogsEntity?>? symptomLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .filter('details->symptom_id', 'eq', id)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        SymptomLogsEntity entity = SymptomLogsEntity.fromJson(element);
        symptomLogs.add(entity);
      });
    });
    return symptomLogs;
  }

  Future<Set<String?>> getAllUniqueSymptomNames() async {
    Set<String?> names = {};
    await _supabaseClient
        .from(_tableName)
        .select('details')
        .eq('user_id', _userId)
        .then((response) {
      response.forEach((element) {
        SymptomLogsEntity entity = SymptomLogsEntity.fromJson(element);
        if (entity.details?.name != null) {
          names.add(entity.details!.name);
        }
      });
    });
    return names;
  }

  Future<List<SymptomLogsEntity>> getSymptomByIds({
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

    List<SymptomLogsEntity> entities = [];
    result.forEach((entry) => entities.add(SymptomLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<SymptomLogsEntity?> addSymptom({
    required SymptomLogsEntity symptomLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(symptomLogsEntity.toJson())
        .select();
    if (result == null || result.length == 0) {
      return null;
    }
    return SymptomLogsEntity.fromJson(result.first);
  }

  Future<SymptomLogsEntity?> updateSymptomLogWithId({
    required int log_id,
    required SymptomLogsEntity symptomLogsEntity,
  }) async {
    SymptomLogsEntity? symptom = null;
    final result = await _supabaseClient
        .from(_tableName)
        .update(symptomLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id)
        .select();
    if (result != null && result.length > 0) {
      symptom = SymptomLogsEntity.fromJson(result.first);
    }
    return symptom;
  }

  deleteSymptomLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllSymptoms() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {
  await setUpApp();

  AuthenticationService authenticationService = AuthenticationService();
  User? user = await authenticationService.emailLogIn(
    email: toastieEmail,
    password: toastiePassword,
  );

  if (user != null) {
    SymptomLogsRepository symptomLogsRepository = SymptomLogsRepository();

    // Get
    // DateTime startOfDay = DateTime(date.year, date.month, date.day);
    // int startOfDayUnix = startOfDay.millisecondsSinceEpoch ~/ 1000;
    // DateTime endOfDay =
    //     DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
    // int endOfDayUnix = endOfDay.millisecondsSinceEpoch ~/ 1000;
    List<SymptomLogsEntity?>? symptomLogsEntities =
        await symptomLogsRepository.getSymptomDetailsForRange(
      startOfUnix: 1720533600,
      endOfUnix: 1720533600,
    );
    print(symptomLogsEntities);

    // Add
    // DateTime now = DateTime.now().add(Duration(days: 1));
    // int unixTimestamp = now.millisecondsSinceEpoch ~/ 1000;
    // symptomLogsRepository.addSymptom(
    //   symptomLogsEntity: SymptomLogsEntity(
    //     user_id: user.id,
    //     date_time: unixTimestamp,
    //     name: 'new',
    //     severity: SymptomSeverity.mild,
    //   ),
    // );

    // Update
    // symptomLogsRepository.updateSymptomLogWithId(
    //   log_id: 7,
    //   symptomLogsEntity: SymptomLogsEntity(name: 'test change'),
    // );

    // Delete
    // symptomLogsRepository.deleteSymptomLogWithId(log_id: 1);
    // symptomLogsRepository.deleteAllSymptoms();
  }
}
