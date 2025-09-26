import 'dart:io';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/services/authentication/authentication_service.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/services/test_account.dart';

class AudioUploadClient {
  AudioUploadClient() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }
  static final String _bucketName = 'magic_audio_tracker';
  late SupabaseClient _supabaseClient;
  late String _userId;

  addAudio({
    required File file,
    required String audio_id,
  }) {
    _supabaseClient.storage
        .from(_bucketName)
        .upload('$_userId/$audio_id', file);
  }

  Future<Uint8List?> getAudio(String name) async {
    // Search if there are any audios with the given name.
    List items = await _supabaseClient.storage.from(_bucketName).list(
          path: '$_userId',
          searchOptions: SearchOptions(
            search: name,
          ),
        );
    if (items.isEmpty) {
      return null;
    }

    // Download file.
    return _supabaseClient.storage.from(_bucketName).download('$_userId/$name');
  }

  deleteAudio({required String audio_id}) {
    _supabaseClient.storage.from(_bucketName).remove(['$_userId/$audio_id']);
  }

  deleteAllAudios() async {
    final filesToDelete =
        await _supabaseClient.storage.from(_bucketName).list(path: '$_userId');
    filesToDelete.forEach((file) {
      _supabaseClient.storage
          .from(_bucketName)
          .remove(['$_userId/${file.name}']);
    });
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
