import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/services/services.dart';

class LabReportRepository {
  LabReportRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'lab_report';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<List<LabReportEntity>> getLabReportsByType({
    required ReportType type,
  }) async {
    List<LabReportEntity> labReports = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .eq('type', type.name)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        LabReportEntity entity = LabReportEntity.fromJson(element);
        labReports.add(entity);
      });
    });
    return labReports;
  }

  Future<List<LabReportEntity>> getLabReportsForUnixTimeRange({
    required int startUnixTime,
    required int endUnixTime,
  }) async {
    List<LabReportEntity> labReports = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startUnixTime)
        .lte('date_time', endUnixTime)
        .order('date_time', ascending: true)
        .then((response) {
      response.forEach((element) {
        LabReportEntity entity = LabReportEntity.fromJson(element);
        labReports.add(entity);
      });
    });
    return labReports;
  }

  Future<List<LabReportEntity>> getReportByIds({
    required Set<int> ids,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .in_('id', ids.toList()) as List;
    if (result.length == 0) {
      return [];
    }

    List<LabReportEntity> entities = [];
    result.forEach((entry) => entities.add(LabReportEntity.fromJson(entry)));
    return entities;
  }

  Future<LabReportEntity?> addLabReport({
    required LabReportEntity labReportEntity,
  }) async {
    final report = await _supabaseClient
        .from(_tableName)
        .insert(labReportEntity.toJson())
        .select()
        .maybeSingle();

    if (report == null) {
      return null;
    }

    return LabReportEntity.fromJson(report);
  }

  updateLabReportWithId({
    required int id,
    required LabReportEntity labReportEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(labReportEntity.toJson())
        .eq('user_id', _userId)
        .eq('id', id);
  }

  deleteLabReportWithId({required int id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('id', id);
  }

  deleteAllLabReports() async {
    await _supabaseClient.from(_tableName).delete().eq('user_id', _userId);
  }
}

void main() async {}
