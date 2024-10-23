import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:report/devices.dart';
import 'package:report/firebase_options.dart';
import 'theme/app_theme.dart';

void main() async {
  Gemini.init(apiKey: "AIzaSyDAG8-2yhi-Qp2bkzodeo8tk0_9QZXgnxA");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Report Rover',
      theme: theme.light,
      home: const Devices(),
    );
  }
}
