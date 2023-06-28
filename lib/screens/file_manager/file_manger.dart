import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String?> get _directoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  Future<File> get _imageFile async {
    final path = await _directoryPath;
    return File('$path/cheetah_image');
  }

  Future<Uint8List> writeImageFile(Future<Uint8List> img) async {
    File file = await _imageFile;
    await file.writeAsBytes(await img);
    return img;
  }

  Future<Uint8List?> readImageFile() async {
    File file = await _imageFile;
    Uint8List byteList;

    if (await file.exists()) {
      try {
        byteList = await file.readAsBytes();
        return byteList;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
