import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/clients/lab_report_upload_client.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/lab_report/lab_report_entity.dart';
import 'package:toastie/repositories/lab_report_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/time_utils.dart';
import 'package:toastie/utils/time/unix_date_range.dart';
import 'package:uuid/uuid.dart';

class LabReportService {
  LabReportService() {}

  Future<List<LabReportEntity>> getLabReportsByType({
    required ReportType type,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<LabReportRepository>().getLabReportsByType(
      type: type,
    );
  }

  Future<List<LabReportEntity>> getLabReportsForDay({
    required DateTime date,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<LabReportRepository>().getLabReportsForUnixTimeRange(
      startUnixTime: unixTime.startTime,
      endUnixTime: unixTime.endTime,
    );
  }

  Future<List<LabReportEntity>> getReportByIds({
    required Set<int> ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<LabReportRepository>().getReportByIds(
      ids: ids,
    );
  }

  Future<List<LabReportEntity>> getLabReportsForDateRange({
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
    return locator<LabReportRepository>().getLabReportsForUnixTimeRange(
      startUnixTime: unixTime.startTime,
      endUnixTime: unixTime.endTime,
    );
  }

  /**
   * Uploads photo to storage and adds photo to the photo logs table.
   * @return list of photo ids that were added.
   */
  Future<LabReportEntity?> addLabReport({
    required DateTime dateTime,
    required List<File> files,
    String? name,
    String? type,
    String? examinedBy,
    String? referredBy,
    String? notes,
  }) async {
    if (!shouldRunRpc) {
      return LabReportEntity(id: -1, photo_ids: ['fake photo']);
    }

    List<String> photoIds = [];
    List<Future> futures = [];
    for (File file in files) {
      String uuid = Uuid().v4();
      photoIds.add(uuid);
      futures.add(
        locator<LabReportUploadClient>().addPhoto(
          file: file,
          photo_id: uuid,
        ),
      );
    }

    LabReportEntity entity = LabReportEntity(
      name: name,
      user_id: locator<SupabaseClient>().auth.currentUser!.id,
      photo_ids: photoIds,
      date_time: convertToUnixDateTime(dateTime),
      type: type != null
          ? ReportType.values.byName(type.toLowerCase())
          : ReportType.other,
      examined_by: examinedBy,
      referred_by: referredBy,
      notes: notes,
    );

    LabReportEntity? report = await locator<LabReportRepository>().addLabReport(
      labReportEntity: entity,
    );

    await Future.wait(futures);

    return report;
  }

  /**
   * Uploads photo to storage.
   * @return uuid of the uploaded photo.
   */
  Future<String> addPhoto({required File file}) async {
    if (!shouldRunRpc) {
      return '';
    }

    final String uuid = Uuid().v4();
    await locator<LabReportUploadClient>().addPhoto(
      file: file,
      photo_id: uuid,
    );
    return uuid;
  }

  Future<void> updateLabReport({
    required int id,
    required LabReportEntity entity,
  }) async {
    if (!shouldRunRpc) {
      return;
    }

    await locator<LabReportRepository>().updateLabReportWithId(
      id: id,
      labReportEntity: entity,
    );
  }

  /** Deletes photo from storage. */
  Future<void> deletePhoto({required String photo_id}) async {
    if (!shouldRunRpc) {
      return;
    }

    await locator<LabReportUploadClient>().deletePhoto(photo_id: photo_id);
  }

  deleteLabReportWithId({required int id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<LabReportUploadClient>().deleteLabReportWithId(id: id);
    locator<LabReportRepository>().deleteLabReportWithId(id: id);
  }

  deleteAllLabReports() {
    if (!shouldRunRpc) {
      return;
    }

    locator<LabReportUploadClient>().deleteAllLabReports();
    locator<LabReportRepository>().deleteAllLabReports();
  }
}
