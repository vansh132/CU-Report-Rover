import 'package:flutter/material.dart';
import 'package:report/auto_report.dart';
import 'package:report/mobile_auto_report.dart';
import 'package:report/temp.dart';
// import 'package:report/temp.dart';

class Devices extends StatelessWidget {
  const Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= 750 ? const AutoReport() : const MobileAutoReport();
  }
}
