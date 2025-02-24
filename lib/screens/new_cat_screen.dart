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
  final TextEditingController _detailsController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCat() async {
    if (_nameController.text.isNotEmpty && _image != null) {
      String imagePath = await FileService.saveImage(_image!);
      Cat newCat = Cat(name: _nameController.text, details: _detailsController.text, imagePath: imagePath);

      List<Cat> cats = await FileService.loadCats();
      cats.add(newCat);
      await FileService.saveCats(cats);

      Navigator.pop(context, true); // 📌 ส่ง true กลับไปที่ cat_list_screen.dart
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มแมวใหม่')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'ชื่อแมว')),
            TextField(controller: _detailsController, decoration: const InputDecoration(labelText: 'รายละเอียด')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveCat,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('บันทึกแมว', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
