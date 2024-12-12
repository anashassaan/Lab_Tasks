// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lab08/lab9/user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const UserScreen(),
    );
  }
}
