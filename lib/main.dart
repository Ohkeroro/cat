import 'package:cat/screens/home_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HomeScreen(), 
    );
  }
}
