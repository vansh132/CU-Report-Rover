import 'package:flutter/material.dart';
import 'package:report/report_form.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light,
      home: const ReportForm(),
    );
  }
}
