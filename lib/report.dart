import 'package:flutter/material.dart';

class ReportScreenMain extends StatefulWidget {
  const ReportScreenMain({super.key});

  @override
  State<ReportScreenMain> createState() => _ReportScreenMainState();
}

class _ReportScreenMainState extends State<ReportScreenMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Main Screen"),
      ),
    );
  }
}
