import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/clients/photo_upload_utils.dart';
import 'package:toastie/services/services.dart';

class LabReportUploadClient {
  LabReportUploadClient() {
    _supabaseClient = locator<SupabaseClient>();
    _userId = _supabaseClient.auth.currentUser!.id;
  }

  static final String _bucketName = 'lab-report';
  late SupabaseClient _supabaseClient;
  late String _userId;

  Future addPhoto({
    required File file,
    required String photo_id,
  }) async {
    File? compressedPhoto = await compressImage(file: file);
    if (compressedPhoto == null) {
      compressedPhoto = file;
    }

    await locator<SupabaseClient>()
        .storage
        .from(_bucketName)
        .upload('$_userId/$photo_id', compressedPhoto);
  }

  Future<Uint8List?> getPhoto(String name) async {
    try {
      // Search if there are any photos with the given name and download.
      return await _supabaseClient.storage
          .from(_bucketName)
          .download('$_userId/$name');
    } catch (e) {
      // Error downloading image
      return null;
    }
  }

  deletePhoto({required String photo_id}) async {
    await _supabaseClient.storage
        .from(_bucketName)
        .remove(['$_userId/$photo_id']);
  }

  deleteLabReportWithId({required int id}) async {
    await _supabaseClient.storage.from(_bucketName).remove(['$_userId/$id']);
  }

  deleteAllLabReports() async {
    final filesToDelete =
        await _supabaseClient.storage.from(_bucketName).list(path: '$_userId');
    filesToDelete.forEach((file) async {
      await _supabaseClient.storage
          .from(_bucketName)
          .remove(['$_userId/${file.name}']);
    });
  }
}
