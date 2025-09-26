import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/medication_logs_entity.dart';
import 'package:toastie/repositories/trackers/medication_logs_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class MedicationLogsService {
  MedicationLogsService() {
    _supabaseClient = locator<SupabaseClient>();
    _user = _supabaseClient.auth.currentUser!;
  }
  late SupabaseClient _supabaseClient;
  late User _user;

  Future<List<MedicationLogsEntity?>?> getMedicationDetailsForDay({
    required DateTime date,
  }) async {
    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<MedicationLogsRepository>().getMedicationDetailsForDay(
      startOfDayUnix: unixTime.startTime,
      endOfDayUnix: unixTime.endTime,
    );
  }

  Future<List<MedicationLogsEntity>> getMedicationDetailsForDateRange({
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
    return locator<MedicationLogsRepository>().getMedicationDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  // Get all unique medication names tracked for the user.
  Future<Set<String?>?> getAllUniqueMedicationNames() async {
    return await locator<MedicationLogsRepository>()
        .getAllUniqueMedicationNames();
  }

  Future<List<MedicationLogsEntity>> getMedicationByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<MedicationLogsRepository>().getMedicationByIds(
      log_ids: log_ids,
    );
  }

  Future<void> addMedication({
    required int unixDateTime,
    required String name,
    double quantity = 1,
    String? dose,
    int? scheduleId = null,
  }) async {
    await locator<MedicationLogsRepository>().addMedication(
      medicationLogsEntity: MedicationLogsEntity(
        user_id: _user.id,
        date_time: unixDateTime,
        name: name.toLowerCase(),
        quantity: quantity,
        dose: dose,
        schedule_id: scheduleId,
      ),
    );
  }

  updateMedicationLogWithId({
    required int log_id,
    int? unixDateTime,
    String? name,
    double? quantity,
    String? dose,
  }) {
    MedicationLogsEntity entity = MedicationLogsEntity();
    entity.date_time ??= unixDateTime;
    entity.name ??= name?.toLowerCase();
    entity.quantity ??= quantity;
    entity.dose ??= dose;

    locator<MedicationLogsRepository>().updateMedicationLogWithId(
      log_id: log_id,
      medicationLogsEntity: entity,
    );
  }

  deleteMedicationLogWithId({required int log_id}) {
    locator<MedicationLogsRepository>()
        .deleteMedicationLogWithId(log_id: log_id);
  }

  deleteAllMedications() {
    locator<MedicationLogsRepository>().deleteAllMedications();
  }
}
