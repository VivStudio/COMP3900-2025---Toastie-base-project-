import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/symptom/symptom_logs_entity.dart';
import 'package:toastie/entities/trackers/symptom/symptoms_entity.dart';
import 'package:toastie/repositories/trackers/symptom/symptom_creation_repository.dart';
import 'package:toastie/repositories/trackers/symptom/symptom_logs_repository.dart';
import 'package:toastie/repositories/trackers/symptom/symptoms_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class SymptomLogsService {
  SymptomLogsService() {
    _supabaseClient = locator<SupabaseClient>();
    _symptomsRepository = locator<SymptomsRepository>();
    _symptomCreationRepository = locator<SymptomCreationRepository>();

    _user = _supabaseClient.auth.currentUser!;
  }

  late SupabaseClient _supabaseClient;
  // Handles retrieving and updating symptoms, including managing associated details like aliases.
  late SymptomsRepository _symptomsRepository;
  // Facilitates the creation of new, independent symptoms (not linked as aliases to existing symptoms).
  late SymptomCreationRepository _symptomCreationRepository;
  late User _user;

  Future<List<SymptomLogsEntity?>?> getSymptomDetailsForDay({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<SymptomLogsRepository>().getSymptomDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<SymptomLogsEntity?>?> getSymptomDetailsForDateRange({
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
    return locator<SymptomLogsRepository>().getSymptomDetailsForRange(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
    );
  }

  Future<List<SymptomLogsEntity?>?> getSymptomDetailsForWeekByName({
    required DateTime date,
    required String name,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertToUnixWeekRange(date);
    final lowerCaseName = name.toLowerCase();

    // Try to string match on symptom name.
    SymptomsEntity? nameMatch = await _symptomsRepository
        .getSymptomThatMatchesName(name: lowerCaseName);
    if (nameMatch == null) {
      // Try to string match on symptom alias name.
      nameMatch = await _symptomsRepository.getSymptomThatMatchesAlias(
        aliasName: lowerCaseName,
      );
    }

    if (nameMatch == null) return [];

    return locator<SymptomLogsRepository>().getSymptomDetailsForRangeById(
      startOfUnix: unixTime.startTime,
      endOfUnix: unixTime.endTime,
      id: nameMatch.id!,
    );
  }

  Future<List<SymptomLogsEntity>> getSymptomByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<SymptomLogsRepository>().getSymptomByIds(
      log_ids: log_ids,
    );
  }

  Future<SymptomLogsEntity?> createOrAddSymptom({
    required int unixDateTime,
    required String name,
    required SymptomSeverity severity,
  }) async {
    if (!shouldRunRpc) {
      return SymptomLogsEntity(
        log_id: -1,
        details: SymptomDetails(
          name: 'test',
          symptom_id: -1,
        ),
      );
    }

    // Symptom name must be in lower case to match database entries.
    String lowerCaseName = name.toLowerCase();

    SymptomsEntity? entity = await _getSymptomEntityThatMatchesName(
      name: lowerCaseName,
      unixDateTime: unixDateTime,
    );
    if (entity != null) {
      return _addSymptomLog(
        unixDateTime: unixDateTime,
        name: name,
        symptomId: entity.id!,
        severity: severity,
      );
    }

    return null;
  }

  Future<SymptomLogsEntity?> _addSymptomLog({
    required int unixDateTime,
    required String name,
    required int symptomId,
    required SymptomSeverity severity,
  }) async {
    SymptomLogsEntity? entity =
        await locator<SymptomLogsRepository>().addSymptom(
      symptomLogsEntity: SymptomLogsEntity(
        user_id: _user.id,
        date_time: unixDateTime,
        details: SymptomDetails(
          name: name,
          symptom_id: symptomId,
        ),
        severity: severity,
      ),
    );
    return entity;
  }

  /**
   * Determines whether to create a new symptom or add it as an alias of an existing symptom.
   * 1. Try to string match on symptom name.
   * 2. Try to string match on symptom alias name.
   * 3. Create new symptom if none of the above matches. Newly created symptom will also be added to the symptom_creation table to allow us to do proper categorisation and backfill later.
   */
  Future<SymptomsEntity?> _getSymptomEntityThatMatchesName({
    required String name,
    required int unixDateTime,
  }) async {
    if (!shouldRunRpc) {
      SymptomsEntity(id: -1, name: 'test');
    }

    // Try to string match on symptom name.
    SymptomsEntity? nameMatch =
        await _symptomsRepository.getSymptomThatMatchesName(name: name);
    if (nameMatch != null) {
      return nameMatch;
    }

    // Try to string match on symptom alias name.
    SymptomsEntity? aliasMatch =
        await _symptomsRepository.getSymptomThatMatchesAlias(aliasName: name);
    if (aliasMatch != null) {
      return aliasMatch;
    }

    // Otherwise, create new symptom entry.
    // Add to symptoms table.
    SymptomsEntity? newSymptom = await _symptomsRepository.createSymptom(
      name: name,
    );
    if (newSymptom != null) {
      // Add to symptom creation table.
      _symptomCreationRepository.createSymptom(
        symptom: newSymptom,
        unixDateTime: unixDateTime,
      );
    }

    return newSymptom;
  }

  // Get all unique symptom names tracked for the user.
  Future<Set<String?>?> getAllUniqueSymptomNames() async {
    return await locator<SymptomLogsRepository>().getAllUniqueSymptomNames();
  }

  Future<SymptomLogsEntity?> updateSymptomLogWithId({
    required int log_id,
    required int unixDateTime,
    String? name,
    SymptomSeverity? severity,
  }) async {
    if (!shouldRunRpc) {
      return null;
    }

    SymptomLogsEntity entity = SymptomLogsEntity();

    if (name != null && name.isNotEmpty) {
      SymptomsEntity? symptom = await _getSymptomEntityThatMatchesName(
        name: name.toLowerCase(),
        unixDateTime: unixDateTime,
      );
      if (symptom != null) {
        entity.details = SymptomDetails(
          symptom_id: symptom.id!,
          name: name,
        );
      }
    }

    entity.severity ??= severity;
    entity.date_time = unixDateTime;

    return locator<SymptomLogsRepository>().updateSymptomLogWithId(
      log_id: log_id,
      symptomLogsEntity: entity,
    );
  }

  deleteSymptomLogWithId({required int log_id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<SymptomLogsRepository>().deleteSymptomLogWithId(log_id: log_id);
  }

  deleteAllSymptoms() {
    if (!shouldRunRpc) {
      return;
    }

    locator<SymptomLogsRepository>().deleteAllSymptoms();
  }
}
