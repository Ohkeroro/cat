import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cat.dart';

class FileService {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cats.json');
  }

  // ปรับปรุงโมเดล Cat ให้มี userEmail
  static Future<List<Cat>> loadCats() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);
      
      // แปลงข้อมูล JSON เป็นรายการของแมว
      return jsonData.map((e) {
        Map<String, dynamic> catMap = Map<String, dynamic>.from(e);
        
        // ถ้าไม่มี userEmail (ข้อมูลเก่า) ให้กำหนดค่าเริ่มต้นเป็นค่าว่าง
        if (!catMap.containsKey('userEmail')) {
          catMap['userEmail'] = '';
        }
        
        return Cat.fromJson(catMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // เพิ่มเมธอดใหม่สำหรับโหลดแมวเฉพาะของผู้ใช้นั้น
  static Future<List<Cat>> loadCatsByUser(String userEmail) async {
    List<Cat> allCats = await loadCats();
    return allCats.where((cat) => cat.userEmail == userEmail).toList();
  }

  // ปรับปรุงการบันทึกข้อมูลแมว
  static Future<void> saveCats(List<Cat> cats) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(cats.map((e) => e.toJson()).toList()));
  }

  // บันทึกข้อมูลแมวของผู้ใช้ โดยรักษาข้อมูลของผู้ใช้อื่นไว้
  static Future<void> saveCatsByUser(List<Cat> userCats, String userEmail) async {
    // โหลดแมวทั้งหมด
    List<Cat> allCats = await loadCats();
    
    // ลบแมวเก่าของผู้ใช้นี้ออก
    allCats.removeWhere((cat) => cat.userEmail == userEmail);
    
    // เพิ่มแมวใหม่เข้าไป
    allCats.addAll(userCats);
    
    // บันทึกกลับไป
    await saveCats(allCats);
  }

  // ปรับปรุงการบันทึกรูปภาพ
  static Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = await image.copy(newPath);
    return newImage.path;
  }
}