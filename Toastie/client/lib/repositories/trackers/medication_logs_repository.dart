import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/medication_logs_entity.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class MedicationLogsRepository {
  MedicationLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'medication_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<MedicationLogsEntity?>?> getMedicationDetailsForDay({
    required int startOfDayUnix,
    required int endOfDayUnix,
  }) async {
    List<MedicationLogsEntity?>? medicationLogs = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfDayUnix)
        .lte('date_time', endOfDayUnix)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        MedicationLogsEntity entity = MedicationLogsEntity.fromJson(element);
        medicationLogs.add(entity);
      });
    });
    return medicationLogs;
  }

  Future<List<MedicationLogsEntity>> getMedicationDetailsForRange({
    required int startOfUnix,
    required int endOfUnix,
  }) async {
    List<MedicationLogsEntity> medications = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfUnix)
        .lte('date_time', endOfUnix)
        .then((response) {
      response.forEach((element) {
        MedicationLogsEntity entity = MedicationLogsEntity.fromJson(element);
        medications.add(entity);
      });
    });
    return medications;
  }

  Future<Set<String?>> getAllUniqueMedicationNames() async {
    Set<String?> names = {};
    await _supabaseClient
        .from(_tableName)
        .select('name')
        .eq('user_id', _userId)
        .then((response) {
      response.forEach((element) {
        MedicationLogsEntity entity = MedicationLogsEntity.fromJson(element);
        names.add(entity.name);
      });
    });
    return names;
  }

  Future<List<MedicationLogsEntity>> getMedicationByIds({
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

    List<MedicationLogsEntity> entities = [];
    result
        .forEach((entry) => entities.add(MedicationLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<MedicationLogsEntity?> addMedication({
    required MedicationLogsEntity medicationLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(medicationLogsEntity.toJson())
        .select();
    if (result != null) {
      return MedicationLogsEntity.fromJson(result.first);
    }
    return null;
  }

  updateMedicationLogWithId({
    required int log_id,
    required MedicationLogsEntity medicationLogsEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(medicationLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteMedicationLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllMedications() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {
  AuthenticationService authenticationService = AuthenticationService();
  User? user = await authenticationService.emailLogIn(
    email: toastieEmail,
    password: toastiePassword,
  );

  if (user != null) {
    // MedicationLogsRepository medicationLogsRepository =
    //     MedicationLogsRepository();

    // Add
    // DateTime now = DateTime.now().add(Duration(days: 1));
    // int unixTimestamp = now.millisecondsSinceEpoch ~/ 1000;
    // medicationLogsRepository.addMedication(
    //     medicationLogsEntity: MedicationLogsEntity(
    //   log_id: 1,
    //   userId: user.id,
    //   date_time: unixTimestamp,
    //   name: 'new',
    //   // severity: SYMPTOM_SEVERITY.MILD,
    // ));
  }
}
