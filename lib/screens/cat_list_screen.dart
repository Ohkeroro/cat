import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';

class CatListScreen extends StatefulWidget {
  const CatListScreen({super.key});

  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  List<Cat> _cats = [];

  @override
  void initState() {
    super.initState();
    _initializeCats();
  }

  Future<void> _initializeCats() async {
    List<Cat> cats = await FileService.loadCats();

    // 📌 ถ้ายังไม่มีข้อมูล ให้เพิ่มแมวตัวอย่างจาก assets/images/
    if (cats.isEmpty) {
      cats = [
        Cat(name: "เหมียว", details: "แมวไทยขนสั้น น่ารักมาก!", imagePath: "assets/images/cat1.jpg"),
        Cat(name: "มูมู่", details: "แมวขาวตาสองสี ตัวอ้วนกลม", imagePath: "assets/images/cat2.jpg"),
        Cat(name: "โบ้", details: "แมวส้มจอมซน ชอบเล่นของ", imagePath: "assets/images/cat3.jpg"),
        Cat(name: "มินิ", details: "แมวพันธุ์ Scottish Fold หูพับ", imagePath: "assets/images/cat4.jpg"),
        Cat(name: "เลม่อน", details: "แมวขาวเหลืองสุดน่ารัก", imagePath: "assets/images/cat5.jpg"),
        Cat(name: "ช็อปเปอร์", details: "แมวสามสี ตัวเล็ก ขี้อ้อน", imagePath: "assets/images/cat6.jpg"),
        Cat(name: "คิตตี้", details: "แมวเปอร์เซีย ขนนุ่มฟู", imagePath: "assets/images/cat7.jpg"),
        Cat(name: "ข้าวปั้น", details: "แมวสีดำสุดเท่ ขี้อ้อน", imagePath: "assets/images/cat8.jpg"),
        Cat(name: "พิกาจู", details: "แมวตัวเล็ก กระโดดเก่ง", imagePath: "assets/images/cat9.jpg"),
        Cat(name: "มะลิ", details: "แมวสวย เรียบร้อย ไม่ซน", imagePath: "assets/images/cat10.jpg"),
      ];
      await FileService.saveCats(cats);
    }

    setState(() {
      _cats = cats;
    });
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
                  'ยังไม่มีแมวในระบบ 😿',
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _loadImage(cat.imagePath),
                      ),
                      title: Text(cat.name, style: GoogleFonts.notoSansThai(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text(cat.details, style: GoogleFonts.notoSansThai(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // 📌 ฟังก์ชันโหลดรูปจาก assets หรือจากไฟล์ที่ผู้ใช้เพิ่ม
  Widget _loadImage(String imagePath) {
    if (imagePath.startsWith("assets/")) {
      return Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath), width: 60, height: 60, fit: BoxFit.cover);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('🐱 รายการแมว'),
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
