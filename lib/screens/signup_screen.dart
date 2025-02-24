import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "❌ กรุณากรอกข้อมูลให้ครบ!";
        _successMessage = '';
      });
      return;
    }

    bool success = await AuthService.register(User(name: name, email: email, password: password));

    if (success) {
      setState(() {
        _successMessage = "✅ สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ";
        _errorMessage = '';
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    } else {
      setState(() {
        _errorMessage = "❌ อีเมลนี้ถูกใช้แล้ว!";
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add, size: 60, color: Colors.orange),
                    const SizedBox(height: 10),
                    const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อ',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                      ),
                    if (_successMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(_successMessage, style: const TextStyle(color: Colors.green)),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('สมัครสมาชิก', style: TextStyle(fontSize: 18)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('มีบัญชีอยู่แล้ว? เข้าสู่ระบบ', style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
