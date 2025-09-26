import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/developer_mode.dart';
import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/repositories/trackers/note_logs_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/unix_date_range.dart';

class NoteLogsService {
  NoteLogsService() {}

  Future<NoteLogsEntity?> getNoteDetailsForDay({required DateTime date}) async {
    if (!shouldRunRpc) {
      return null;
    }

    UnixDateRange unixTime = convertDayToUnixDateRange(date: date);
    return locator<NoteLogsRepository>().getNoteDetailsForDay(
      startOfDayUnix: unixTime.startTime,
      endOfDayUnix: unixTime.endTime,
    );
  }

  Future<List<NoteLogsEntity>> getNotesForDateRange({
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
    return locator<NoteLogsRepository>().getNotesForUnixTimeRange(
      startUnixTime: unixTime.startTime,
      endUnixTime: unixTime.endTime,
    );
  }

  Future<List<NoteLogsEntity>> getNoteByIds({
    required Set<int> log_ids,
  }) async {
    if (!shouldRunRpc) {
      return [];
    }

    return locator<NoteLogsRepository>().getNoteByIds(
      log_ids: log_ids,
    );
  }

  Future addNote({
    required int unixDateTime,
    required String note,
  }) async {
    await locator<NoteLogsRepository>().addNote(
      noteLogsEntity: NoteLogsEntity(
        user_id: locator<SupabaseClient>().auth.currentUser!.id,
        date_time: unixDateTime,
        note: note,
      ),
    );
  }

  Future updateNoteLogWithId({
    required int log_id,
    int? unixDateTime,
    String? note,
  }) async {
    if (!shouldRunRpc) {
      return;
    }

    NoteLogsEntity entity = NoteLogsEntity();
    entity.date_time ??= unixDateTime;
    entity.note ??= note;

    await locator<NoteLogsRepository>().updateNoteLogWithId(
      log_id: log_id,
      noteLogsEntity: entity,
    );
  }

  deleteNoteLogWithId({required int log_id}) {
    if (!shouldRunRpc) {
      return;
    }

    locator<NoteLogsRepository>().deleteNoteLogWithId(log_id: log_id);
  }

  deleteAllNotes() {
    if (!shouldRunRpc) {
      return;
    }

    locator<NoteLogsRepository>().deleteAllNotes();
  }
}
