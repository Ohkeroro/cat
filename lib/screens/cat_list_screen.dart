import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';
import 'new_cat_screen.dart';

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
    _loadCats();
  }

  Future<void> _loadCats() async {
    List<Cat> cats = await FileService.loadCats();
    setState(() {
      _cats = cats;
    });
  }

  Future<void> _refreshCats() async {
    List<Cat> cats = await FileService.loadCats();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewCatScreen()),
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
