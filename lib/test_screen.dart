import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:report/report.dart';
import 'package:report/report_form.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Uint8List webImage = Uint8List(8);
  File? webImage;
  Uint8List? webImageUint8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Hello World'),
                ElevatedButton(
                  onPressed: () {
                    // navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportForm()),
                    );
                  },
                  child: const Text("Report"),
                ),
                ElevatedButton(
                  onPressed: () => uploadImage(),
                  child: const Text("Upload image"),
                ),
              ],
            ),
            const SizedBox(height: 50),
            webImageUint8 == null
                ? const Text("No image")
                : Image.memory(webImageUint8!),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReportScreenMain()),
                );
              },
              child: Text("Main Screen"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    // WEB
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      var f = await result.files.single.xFile.readAsBytes();
      setState(() {
        webImageUint8 = f;
      });
    } else {
      // User canceled the picker
    }
  }
}
