import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  /// Compresses a file to a target quality and minWidth.
  /// Returns the compressed file.
  static Future<File> compressFile(File file,
      {int quality = 75, int minWidth = 1080}) async {
    // Create output path in temp directory to avoid overwriting originals or permission issues
    final tempDir = await getTemporaryDirectory();
    final fileName = p.basename(file.path);
    final targetPath = p.join(tempDir.path,
        "compressed_${DateTime.now().millisecondsSinceEpoch}_$fileName");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
    );

    if (result == null) {
      // Compression failed, return original
      return file;
    }

    return File(result.path);
  }
}
