import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';
import 'new_cat_screen.dart';
import '../models/user.dart'; // เพิ่ม import user

class CatListScreen extends StatefulWidget {
  final User user; // เพิ่มพารามิเตอร์เพื่อรับข้อมูล user
  
  const CatListScreen({super.key, required this.user});

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  List<Cat> _cats = [];

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    // โหลดเฉพาะแมวของผู้ใช้ปัจจุบัน
    List<Cat> cats = await FileService.loadCatsByUser(widget.user.email);
    setState(() {
      _cats = cats;
    });
  }

  Future<void> _refreshCats() async {
    // โหลดเฉพาะแมวของผู้ใช้ปัจจุบัน
    List<Cat> cats = await FileService.loadCatsByUser(widget.user.email);
    setState(() {
      _cats = cats;
    });
  }

  // ปรับปรุงฟังก์ชันลบแมวให้ทำงานกับการแยกข้อมูลผู้ใช้
  Future<void> _deleteCat(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ "${_cats[index].name}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirmDelete) {
      // ถ้าชื่อไฟล์ไม่ใช่ assets ให้ลบไฟล์รูปภาพด้วย
      if (!_cats[index].imagePath.startsWith('assets/')) {
        try {
          File imageFile = File(_cats[index].imagePath);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          print('Error deleting image file: $e');
        }
      }

      // ลบแมวออกจากรายการ
      _cats.removeAt(index);
      
      // บันทึกข้อมูลแมวที่เหลือของผู้ใช้นี้
      await FileService.saveCatsByUser(_cats, widget.user.email);
      
      // อัปเดตหน้าจอ
      setState(() {});
      
      // แสดงข้อความแจ้งเตือนว่าลบสำเร็จแล้ว
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ลบข้อมูลแมวเรียบร้อยแล้ว')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _cats.isEmpty
            ? const Center(
                child: Text(
                  'ยังไม่มีแมวในระบบ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cats.length,
                itemBuilder: (context, index) {
                  Cat cat = _cats[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Dismissible(
                      key: Key(cat.name + DateTime.now().toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('ยืนยันการลบ'),
                            content: Text('คุณต้องการลบ "${cat.name}" หรือไม่?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('ยกเลิก'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        _deleteCat(index);
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _loadImage(cat.imagePath),
                        ),
                        title: Text(cat.name, style: GoogleFonts.notoSansThai(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(cat.details, style: GoogleFonts.notoSansThai(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCat(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCatScreen(userEmail: widget.user.email), // ส่ง email ไปด้วย
            ),
          );
          if (result == true) {
            _refreshCats(); 
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _loadImage(String imagePath) {
    if (imagePath.startsWith("assets/")) {
      return Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath), width: 60, height: 60, fit: BoxFit.cover);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('แมวเหมียว MEOW MEOW'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
    );
  }
}
