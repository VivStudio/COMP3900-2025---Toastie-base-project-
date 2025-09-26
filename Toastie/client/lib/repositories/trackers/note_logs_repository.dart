import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/trackers/note_logs_entity.dart';
import 'package:toastie/services/services.dart';

class NoteLogsRepository {
  NoteLogsRepository() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _tableName = 'note_logs';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future<NoteLogsEntity?> getNoteDetailsForDay({
    required int startOfDayUnix,
    required int endOfDayUnix,
  }) async {
    NoteLogsEntity? noteLog = null;
    final List response = await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startOfDayUnix)
        .lte('date_time', endOfDayUnix)
        .limit(1);
    if (response.length >= 1) {
      noteLog = NoteLogsEntity.fromJson(response.first);
    }
    return noteLog;
  }

  Future<List<NoteLogsEntity>> getNotesForUnixTimeRange({
    required int startUnixTime,
    required int endUnixTime,
  }) async {
    List<NoteLogsEntity> notes = [];
    await _supabaseClient
        .from(_tableName)
        .select()
        .eq('user_id', _userId)
        .gte('date_time', startUnixTime)
        .lte('date_time', endUnixTime)
        .then((response) {
      response.forEach((element) {
        NoteLogsEntity entity = NoteLogsEntity.fromJson(element);
        notes.add(entity);
      });
    });
    return notes;
  }

  Future<List<NoteLogsEntity>> getNoteByIds({
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

    List<NoteLogsEntity> entities = [];
    result.forEach((entry) => entities.add(NoteLogsEntity.fromJson(entry)));
    return entities;
  }

  Future<NoteLogsEntity?> addNote({
    required NoteLogsEntity noteLogsEntity,
  }) async {
    final result = await _supabaseClient
        .from(_tableName)
        .insert(noteLogsEntity.toJson())
        .select();
    if (result == null || result.length == 0) {
      return null;
    }
    return NoteLogsEntity.fromJson(result.first);
  }

  updateNoteLogWithId({
    required int log_id,
    required NoteLogsEntity noteLogsEntity,
  }) async {
    await _supabaseClient
        .from(_tableName)
        .update(noteLogsEntity.toJson())
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteNoteLogWithId({required int log_id}) async {
    await _supabaseClient
        .from(_tableName)
        .delete()
        .eq('user_id', _userId)
        .eq('log_id', log_id);
  }

  deleteAllNotes() async {
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
  //   NoteLogsRepository noteLogsRepository = NoteLogsRepository();
  // }
}
