import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_service.dart';
import '../models/cat.dart';
import '../models/user.dart';
import 'login_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final User user;
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
    // โหลดเฉพาะแมวของผู้ใช้ปัจจุบัน
    List<Cat> cats = await FileService.loadCatsByUser(widget.user.email);
    setState(() => _catCount = cats.length);
  }
  
  // เพิ่มฟังก์ชัน logout
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ปิด dialog
              // นำผู้ใช้กลับไปยังหน้า login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // ลบทุก routes ก่อนหน้านี้ออกจาก stack
              );
            },
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        centerTitle: true,
        actions: [
          // เพิ่มปุ่ม logout บน AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
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
                _buildStatItem('แมวของฉัน', '$_catCount ตัว'),
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