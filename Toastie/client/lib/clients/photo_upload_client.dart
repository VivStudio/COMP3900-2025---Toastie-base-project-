import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/clients/photo_upload_utils.dart';
import 'package:toastie/services/services.dart';

class PhotoUploadClient {
  PhotoUploadClient() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _bucketName = 'magic_photo_tracker';
  late SupabaseClient _supabaseClient;
  late String _userId;

  addPhoto({
    required File file,
    required String photo_id,
  }) async {
    File? compressedPhoto = await compressImage(file: file);
    if (compressedPhoto == null) {
      compressedPhoto = file;
    }

    locator<SupabaseClient>()
        .storage
        .from(_bucketName)
        .upload('$_userId/$photo_id', compressedPhoto);
  }

  Future<Uint8List?> getPhoto(String name) async {
    // Search if there are any photos with the given name.
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

  deletePhoto({required String photo_id}) async {
    _supabaseClient.storage.from(_bucketName).remove(['$_userId/$photo_id']);
  }

  deleteAllPhotos() async {
    final filesToDelete =
        await _supabaseClient.storage.from(_bucketName).list(path: '$_userId');
    filesToDelete.forEach((file) {
      _supabaseClient.storage
          .from(_bucketName)
          .remove(['$_userId/${file.name}']);
    });
  }
}
