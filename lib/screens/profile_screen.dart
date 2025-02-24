import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'saved_cats_screen.dart'; // ✅ นำเข้าไฟล์ SavedCatsScreen
import '../services/file_service.dart';
import '../models/cat.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user; // ✅ รับค่า User ที่ล็อกอินอยู่
  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _catCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCatCount();
  }

  Future<void> _loadCatCount() async {
    List<Cat> cats = await FileService.loadCats();
    setState(() => _catCount = cats.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์ของฉัน')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 10),

            // ✅ แสดงชื่อผู้ใช้แทน ID คงที่
            Text(
              'คุณ ${widget.user.name}',
              style: GoogleFonts.notoSansThai(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'อีเมล: ${widget.user.email}',
              style: GoogleFonts.notoSansThai(fontSize: 18, color: Colors.white70),
            ),

            const SizedBox(height: 10),
            _buildStatsCard(),
            const SizedBox(height: 20),

            // ✅ ปุ่มเปิดหน้ารายการแมวที่บันทึกไว้
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedCatsScreen()),
                );
              },
              child: const Text('ดูแมวที่บันทึกไว้'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('สถิติของฉัน', style: GoogleFonts.notoSansThai(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem('แมวทั้งหมด', '$_catCount ตัว'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: GoogleFonts.notoSansThai(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          Text(value, style: GoogleFonts.notoSansThai(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
        ],
      ),
    );
  }
}
