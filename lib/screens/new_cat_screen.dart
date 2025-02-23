import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/file_service.dart';
import '../models/cat.dart';

class NewCatScreen extends StatefulWidget {
  const NewCatScreen({super.key});

  @override
  _NewCatScreenState createState() => _NewCatScreenState();
}

class _NewCatScreenState extends State<NewCatScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  File? _image;

  // 📸 เลือกรูปจากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 💾 บันทึกแมว
  Future<void> _saveCat() async {
    if (_nameController.text.isNotEmpty && _image != null) {
      String imagePath = await FileService.saveImage(_image!);
      Cat newCat = Cat(
        name: _nameController.text,
        details: _noteController.text,
        imagePath: imagePath,
      );

      List<Cat> cats = await FileService.loadCats();
      cats.add(newCat);
      await FileService.saveCats(cats);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🐱 เพิ่มแมวสำเร็จ!')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ กรุณากรอกชื่อและเลือกรูปภาพ!')),
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
            colors: [Colors.blueAccent, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 60, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, 'ชื่อแมว', Icons.pets),
              _buildTextField(_noteController, 'สิ่งที่อยากเขียน', Icons.edit_note),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveCat,
                icon: const Icon(Icons.save),
                label: const Text('บันทึกแมว'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('➕ เพิ่มแมวใหม่'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
