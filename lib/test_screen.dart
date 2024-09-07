import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report/report_form.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Uint8List webImage = Uint8List(8);
  File _file = File("zz");
  Uint8List webImage = Uint8List(10);
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
            (_file.path == "zz")
                ? const Text("No image")
                : (kIsWeb)
                    ? Image.memory(webImage)
                    : Image.file(_file),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    // WEB

    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        _file = File("a");
        webImage = f;
      });
    } else {
      print("No photo");
    }
  }
}
