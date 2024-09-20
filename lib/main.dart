import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:report/report_form.dart';

import 'theme/app_theme.dart';

void main() {
  Gemini.init(apiKey: "AIzaSyD7DgQxEfrw4T6U_C8M67FNk8J_Rka4i5E");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.light,
      home: const ReportForm(),
    );
  }
}
