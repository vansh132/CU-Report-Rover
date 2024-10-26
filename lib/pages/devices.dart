import 'package:flutter/material.dart';
import 'package:report/pages/mobile_auto_report.dart';
import 'package:report/pages/login.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= 750 ? const LoginScreen() : const MobileAutoReport();
  }
}
