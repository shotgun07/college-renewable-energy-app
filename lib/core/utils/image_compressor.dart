import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressor {

  static Future<File> compressFile(File file,
      {int quality = 75, int minWidth = 1080}) async {
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
      return file;
    }

    return File(result.path);
  }
}
