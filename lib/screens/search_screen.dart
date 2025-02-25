import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';
import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  final User user;
  
  const SearchScreen({super.key, required this.user});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Cat> _allCats = [];
  List<Cat> _filteredCats = [];
  TextEditingController _searchController = TextEditingController();
  bool _gridView = false; // เพิ่มตัวแปรควบคุมมุมมอง (กริด/ลิสต์)

  @override
  void initState() {
    super.initState();
    _loadCats();
    _searchController.addListener(_filterCats);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCats() async {
    List<Cat> cats = await FileService.loadCatsByUser(widget.user.email);
    setState(() {
      _allCats = cats;
      _filteredCats = cats;
    });
  }

  void _filterCats() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCats = _allCats;
      });
    } else {
      setState(() {
        _filteredCats = _allCats
            .where((cat) => 
                cat.name.toLowerCase().contains(query) || 
                cat.details.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาแมว'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // สลับมุมมองระหว่างกริดและลิสต์
          IconButton(
            icon: Icon(_gridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _gridView = !_gridView;
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
        ),
      ),
      body: Column(
        children: [
          // ช่องค้นหา
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'ค้นหาแมว',
                hintText: 'ค้นหาตามชื่อหรือรายละเอียด',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          
          // แสดงผลลัพธ์การค้นหา
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.deepOrange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: _filteredCats.isEmpty
                  ? const Center(
                      child: Text(
                        'ไม่พบแมวที่ค้นหา',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  : _gridView 
                      ? _buildGridView() 
                      : _buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCats.length,
      itemBuilder: (context, index) {
        Cat cat = _filteredCats[index];
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
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredCats.length,
      itemBuilder: (context, index) {
        Cat cat = _filteredCats[index];
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: _loadImage(cat.imagePath),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: GoogleFonts.notoSansThai(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat.details,
                      style: GoogleFonts.notoSansThai(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _loadImage(String imagePath) {
    if (imagePath.startsWith("assets/")) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    }
  }
}