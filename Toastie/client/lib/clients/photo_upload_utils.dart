import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<File?> compressImage({required File file}) async {
  final ext = path.extension(file.path).toLowerCase();
  CompressFormat format;

  switch (ext) {
    case '.png':
      format = CompressFormat.png;
      break;
    case '.webp':
      format = CompressFormat.webp;
      break;
    case '.jpg':
    case '.jpeg':
    default:
      format = CompressFormat.jpeg;
      break;
  }

  final dir = await getTemporaryDirectory();
  final uuid = Uuid().v4();
  final targetPath = path.join(
    dir.path,
    'compressed_${uuid}$ext',
  );

  final compressedXFile = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 50, // Compression level (0-100)
    format: format,
  );

  return compressedXFile != null ? File(compressedXFile.path) : null;
}
