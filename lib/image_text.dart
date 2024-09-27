import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class ImageTextConvoScreen extends StatefulWidget {
  const ImageTextConvoScreen({super.key});

  @override
  State<ImageTextConvoScreen> createState() => _ImageTextConvoScreenState();
}

class _ImageTextConvoScreenState extends State<ImageTextConvoScreen> {
  final gemini = Gemini.instance;
  XFile geoTaggedImage = XFile("");
  List<String> data = [];
  final TextEditingController _summary = TextEditingController();
  List<Uint8List> geoTaggedImages = [];
  Uint8List? geoTaggedImageUnit8;

  void selectGeoTaggedImage() async {
    var res = await pickGeoTaggedImages();
    var convertedImage = await res.readAsBytes();
    geoTaggedImages.add(convertedImage);
    setState(() {
      geoTaggedImage = res;
      geoTaggedImageUnit8 = convertedImage;
    });
  }

  void clearGeoTaggedImage() {
    setState(() {
      geoTaggedImage = XFile("");
      geoTaggedImageUnit8 = null;
    });
  }

  Future<XFile> pickGeoTaggedImages() async {
    XFile image = XFile("");
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (files != null && files.files.isNotEmpty) {
        image = files.files[0].xFile;
      } else {
        image = XFile("");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _summary,
                  decoration: const InputDecoration(
                    hintText: "Enter text",
                  ),
                ),
                ElevatedButton(
                  onPressed: selectGeoTaggedImage,
                  child: const Text("Extract basic information"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await gemini.textAndImage(
                      text:
                          "What is the title, Date, Time and venue of event in image? Can you give me response in json as plain text",

                      /// text
                      images: [geoTaggedImages.first],

                      /// list of images
                    ).then((value) {
                      data.add(value?.content?.parts?.last.text ?? '');
                      log(value?.content?.parts?.last.text ?? '');
                    }).catchError((e) {
                      log('textAndImageInput', error: e);
                    });
                    await gemini.textAndImage(
                      text:
                          "I have to prepare report for this event. This is event summary: ${_summary.text}. Can you please write highlights, key takeaways, summary and follow up of this event in paragraph form in json as plain text?",

                      /// text
                      images: [geoTaggedImages.first],

                      /// list of images
                    ).then((value) {
                      data.add(value?.content?.parts?.last.text ?? '');
                      log(value?.content?.parts?.last.text ?? '');
                    }).catchError((e) {
                      log('textAndImageInput', error: e);
                    });
                  },
                  child: const Text("Run gemini"),
                ),
                Text(data.join('\n')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
