import 'package:flutter/material.dart';
import 'cat_list_screen.dart';
import 'profile_screen.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  final User user; // ✅ รับค่า User ที่ล็อกอินอยู่

  const HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const CatListScreen(),
      ProfileScreen(user: widget.user), // ✅ ส่งค่า user ไปที่ ProfileScreen
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'แมวทั้งหมด'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
