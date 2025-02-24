import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';

class SavedCatsScreen extends StatefulWidget {
  const SavedCatsScreen({super.key});

  @override
  _SavedCatsScreenState createState() => _SavedCatsScreenState();
}

class _SavedCatsScreenState extends State<SavedCatsScreen> {
  List<Cat> _cats = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCats();
  }

  Future<void> _loadSavedCats() async {
    List<Cat> cats = await FileService.loadCats();
    setState(() {
      _cats = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แมวที่บันทึกไว้')),
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
                  'ไม่มีแมวที่บันทึกไว้ 😿',
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

  // ✅ โหลดรูปจาก assets หรือจากไฟล์ที่ผู้ใช้เพิ่ม
  Widget _loadImage(String imagePath) {
    if (imagePath.startsWith("assets/")) {
      return Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath), width: 60, height: 60, fit: BoxFit.cover);
    }
  }
}
