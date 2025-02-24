import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cat.dart';

class FileService {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cats.json');
  }

  static Future<List<Cat>> loadCats() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);
      return jsonData.map((e) => Cat.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveCats(List<Cat> cats) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(cats.map((e) => e.toJson()).toList()));
  }

  static Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = await image.copy(newPath);
    return newImage.path;
  }
}
