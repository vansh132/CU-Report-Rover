import 'package:flutter/material.dart';
import 'package:report/auto_report.dart';
import 'package:report/mobile_auto_report.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(width);

    return width > 480 ? const AutoReport() : const MobileAutoReport();
  }
}