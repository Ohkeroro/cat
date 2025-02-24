import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class AuthService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  // ✅ สมัครสมาชิก
  static Future<bool> register(User user) async {
    List<User> users = await loadUsers();

    // เช็คว่ามีอีเมลซ้ำหรือไม่
    if (users.any((u) => u.email == user.email)) {
      return false; // ❌ อีเมลซ้ำ
    }

    users.add(user);
    await _saveUsers(users);
    return true; // ✅ สมัครสมาชิกสำเร็จ
  }

  // ✅ ล็อกอิน
  static Future<User?> login(String email, String password) async {
    List<User> users = await loadUsers();
    
    try {
      return users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null; // ❌ ไม่เจอผู้ใช้
    }
  }

  // ✅ โหลดผู้ใช้ทั้งหมด
  static Future<List<User>> loadUsers() async {
    try {
      final file = await _getFile();
      
      // ถ้ายังไม่มีไฟล์ให้คืนค่าเป็น []
      if (!await file.exists()) return [];

      String content = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(content);

      return jsonData.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return []; // ❌ ถ้ามีข้อผิดพลาด ให้คืนค่าเป็น []
    }
  }

  // ✅ บันทึกข้อมูลผู้ใช้
  static Future<void> _saveUsers(List<User> users) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(users.map((e) => e.toJson()).toList()));
  }
}
