import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';

class MobileAutoReport extends StatefulWidget {
  const MobileAutoReport({super.key});

  @override
  State<MobileAutoReport> createState() => _MobileAutoReportState();
}

class _MobileAutoReportState extends State<MobileAutoReport> {
  final gemini = Gemini.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _impactAnalysisController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _typeOfParticipantsController =
      TextEditingController();
  final TextEditingController _noOfParticipantsController =
      TextEditingController();
  final TextEditingController _highlightsController = TextEditingController();
  final TextEditingController _keyTakeawaysController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _followUpController = TextEditingController();
  final TextEditingController _eventDescriptionGeminiPromptController =
      TextEditingController();
  final TextEditingController _rapporteurNameController =
      TextEditingController();
  final TextEditingController _rapporteurEmailController =
      TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final List<TextEditingController> _speakerNameControllers = [];
  final List<TextEditingController> _speakerPositionControllers = [];
  final List<TextEditingController> _speakerTitleControllers = [];
  final List<TextEditingController> _speakerOrganizationControllers = [];
  final List<TextEditingController> _speakerBioControllers = [];

  bool _analysisCompleted = false;
  bool _additionalInformation = false;
  bool _isEventDetailsGenerated = false;

// Geo-tagged images
  List<XFile> geoTaggedImages = []; // List to store 1 or 2 images
  List<Uint8List>?
      geoTaggedImagesUnit8; // List to store byte data of selected images
// feedback images
  List<XFile> feedBackAnalysisImages = []; // List to store 1 or 2 images
  List<Uint8List>?
      feedBackAnalysisImageUnit8; // List to store byte data of selected images
// activity images
  List<XFile> activityImages = []; // List to store 1 or 2 images
  List<Uint8List>?
      activityImagesUnit8; // List to store byte data of selected images
// attendence images
  List<XFile> attendanceImages = []; // List to store 1 or 2 images
  List<Uint8List>?
      attendanceImagesUnit8; // List to store byte data of selected images

  XFile eventPosterImage = XFile("");
  Uint8List? eventPosterImageUnit8;
  // speaker images
  final List<Uint8List> _speakerImages = [];
  XFile speakerImage = XFile("");
  // File eventPoster = File("");
  final List<Uint8List> _eventPosterForGemini = [];

  bool submitted = false;

  String selectedDepartment = 'Select Department';
  String selectedSchool = 'Select School';
  List<String> departments = [
    'Department of Computer Science',
    'Department of Mathematics',
    'Department of Social Science',
    'Department of Physics',
    'Department of Chemistry',
    'Department of Life Science',
  ];

  List<String> schools = [
    "Select School",
    "School of Business and Management",
    "School of Commerce, Finance and Accountancy",
    "School of Sciences",
    "School of Social Sciences",
  ];

  // Define the map of schools to their respective departments
  Map<String, List<String>> schoolDepartments = {
    'School of Sciences': [
      'Department of Computer Science',
      'Department of Mathematics',
      'Department of Physics',
      'Department of Chemistry',
      'Department of Life Science',
    ],
    'School of Commerce, Finance and Accountancy': [
      'Department of Commerce',
      'Department of Professional Studies',
    ],
    'Select School': [
      'Select Department',
    ],
    'School of Business and Management': [
      'Department of Business and Management',
      'Department of Hotel Management',
      'Department of Tourism Management',
    ],
    'School of Social Sciences': [
      'Department of Social Science',
    ],
  };

  // Function to get departments based on the selected school
  List<String> getDepartments(String selectedSchool) {
    // Return the list of departments if the school exists in the map
    return schoolDepartments[selectedSchool] ?? [];
  }

  // Workshop/Seminar/Conference/Training/Events
  final eventTypeValueListenable = ValueNotifier<String?>(null);
  List<String> events = [
    "Workshop",
    "Seminar",
    "Conference",
    "Training",
    "Events",
    "Outreach Programs",
  ];

  //Student/Faculty/Research Scholar
  final participantTypeValueListenable = ValueNotifier<String?>(null);
  List<String> participants = [
    "Student",
    "Faculty",
    "Research Scholar",
  ];

  //Event modes - Online/Offline/Hybrid
  final eventModeValueListenable = ValueNotifier<String?>(null);
  List<String> eventModes = [
    "Online",
    "Offline",
    "Hybrid",
  ];

  void selectGeoTaggedImage() async {
    var res = await pickGeoTaggedImages();
    if (res.isEmpty) {
      Get.snackbar(
        "Error",
        "Please upload at least 1 Geotag image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    List<Uint8List> convertedImages = [];
    for (var file in res) {
      var imageBytes = await file.readAsBytes();
      convertedImages.add(imageBytes);
    }

    setState(() {
      geoTaggedImages = res; // Assuming you store the images in a list.
      geoTaggedImagesUnit8 =
          convertedImages; // Storing byte data for selected images.
    });
  }

  void clearGeoTaggedImages() {
    setState(() {
      geoTaggedImages = []; // Clear the list of images.
      geoTaggedImagesUnit8 = null;
    });
  }

  Future<List<XFile>> pickGeoTaggedImages() async {
    List<XFile> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allow multiple image selection.
      );

      if (files != null && files.files.isNotEmpty && files.files.length <= 2) {
        // Handle the web case where `path` is unavailable
        images = files.files.map((file) {
          return XFile.fromData(
            file.bytes!,
            name: file.name,
            mimeType: file.extension,
          );
        }).toList();
      } else {
        Get.snackbar(
          "Error",
          "Please select up to 2 images only",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
        );
        images = [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }

  void selectFeedbackFormImages() async {
    var res = await pickFeebackFormImages();
    if (res.isEmpty) {
      Get.snackbar(
        "Error",
        "Please upload at least 1 Feedback image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    List<Uint8List> convertedImages = [];
    for (var file in res) {
      var imageBytes = await file.readAsBytes();
      convertedImages.add(imageBytes);
    }

    setState(() {
      feedBackAnalysisImages = res; // Assuming you store the images in a list.
      feedBackAnalysisImageUnit8 =
          convertedImages; // Storing byte data for selected images.
    });
  }

  void clearFeedbackFormImages() {
    setState(() {
      feedBackAnalysisImages = []; // Clear the list of images.
      feedBackAnalysisImageUnit8 = null;
    });
  }

  Future<List<XFile>> pickFeebackFormImages() async {
    List<XFile> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allow multiple image selection.
      );

      if (files != null && files.files.isNotEmpty && files.files.length <= 2) {
        // Handle the web case where `path` is unavailable
        images = files.files.map((file) {
          return XFile.fromData(
            file.bytes!,
            name: file.name,
            mimeType: file.extension,
          );
        }).toList();
      } else {
        Get.snackbar(
          "Error",
          "Please select up to 2 images only",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
        );
        images = [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }

  void selectAttendanceImages() async {
    var res = await pickAttendanceImages();
    if (res.isEmpty) {
      Get.snackbar(
        "Error",
        "Please upload at least 1 Attendence Sheet Image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    List<Uint8List> convertedImages = [];
    for (var file in res) {
      var imageBytes = await file.readAsBytes();
      convertedImages.add(imageBytes);
    }

    setState(() {
      attendanceImages = res; // Assuming you store the images in a list.
      attendanceImagesUnit8 =
          convertedImages; // Storing byte data for selected images.
    });
  }

  void clearAttendanceImages() {
    setState(() {
      attendanceImages = []; // Clear the list of images.
      attendanceImagesUnit8 = null;
    });
  }

  Future<List<XFile>> pickAttendanceImages() async {
    List<XFile> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allow multiple image selection.
      );

      if (files != null && files.files.isNotEmpty && files.files.length <= 2) {
        // Handle the web case where `path` is unavailable
        images = files.files.map((file) {
          return XFile.fromData(
            file.bytes!,
            name: file.name,
            mimeType: file.extension,
          );
        }).toList();
      } else {
        Get.snackbar(
          "Error",
          "Please select up to 2 images only",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
        );
        images = [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }

  void selectActivityImages() async {
    var res = await pickActivityImages();
    if (res.isEmpty) {
      Get.snackbar(
        "Error",
        "Please upload at least 1 Activity Image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }

    List<Uint8List> convertedImages = [];
    for (var file in res) {
      var imageBytes = await file.readAsBytes();
      convertedImages.add(imageBytes);
    }

    setState(() {
      activityImages = res; // Assuming you store the images in a list.
      activityImagesUnit8 =
          convertedImages; // Storing byte data for selected images.
    });
  }

  void clearActivityImages() {
    setState(() {
      activityImages = []; // Clear the list of images.
      activityImagesUnit8 = null;
    });
  }

  Future<List<XFile>> pickActivityImages() async {
    List<XFile> images = [];
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allow multiple image selection.
      );

      if (files != null && files.files.isNotEmpty && files.files.length <= 2) {
        // Handle the web case where `path` is unavailable
        images = files.files.map((file) {
          return XFile.fromData(
            file.bytes!,
            name: file.name,
            mimeType: file.extension,
          );
        }).toList();
      } else {
        Get.snackbar(
          "Error",
          "Please select up to 2 images only",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
        );
        images = [];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return images;
  }

  void selectPosterImage() async {
    var res = await eventPostersImage();
    if (res.path.isEmpty) {
      Get.snackbar(
        "Error",
        "Please Upload Event poster",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
      return;
    }
    var convertedImage = await res.readAsBytes();
    _eventPosterForGemini.add(convertedImage);
    setState(() {
      eventPosterImage = res;
      eventPosterImageUnit8 = convertedImage;
    });
  }

  void clearPosterImage() {
    setState(() {
      eventPosterImage = XFile("");
      eventPosterImageUnit8 = null;
    });
  }

  Future<XFile> eventPostersImage() async {
    XFile image = XFile("");
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (files != null && files.files.isNotEmpty) {
        image = files.files[0].xFile;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return image;
  }

  void clearSpeakerImage() {
    setState(() {
      speakerImage = XFile("");
    });
  }

  Future<XFile> pickSpeakerImages() async {
    XFile image = XFile("");
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (files != null && files.files.isNotEmpty) {
        image = files.files[0].xFile;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return image;
  }

  List<pw.Widget> _buildSpeakerDetailsPdf(pw.Font ttf, pw.Font boldTtf) {
    List<pw.Widget> widgets = [];

    for (int i = 0; i < _speakerNameControllers.length; i++) {
      widgets.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Speaker ${i + 1} Details',
              style: pw.TextStyle(
                  fontSize: 12, fontWeight: pw.FontWeight.bold, font: boldTtf),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow(
                    'Name', _speakerNameControllers[i].text, ttf, boldTtf),
                _buildTableRow('Title/Position',
                    _speakerPositionControllers[i].text, ttf, boldTtf),
                _buildTableRow('Organization',
                    _speakerOrganizationControllers[i].text, ttf, boldTtf),
                _buildTableRow('Title of Presentation',
                    _speakerTitleControllers[i].text, ttf, boldTtf),
              ],
            ),
            pw.SizedBox(height: 12),
          ],
        ),
      );
    }
    return widgets;
  }

  void extractEventDetails(BuildContext context) async {
    if (eventTypeValueListenable.value == null ||
        _noOfParticipantsController.text.isEmpty ||
        _eventDescriptionGeminiPromptController.text.isEmpty ||
        getSelectedParticipantTypes().isEmpty) {
      Get.snackbar("Error", "Please Enter all the details");
      return;
    }

    // List of progress messages to show
    List<String> progressMessages = [
      "Generating highlights of event...",
      "Generating key takeaways of event...",
      "Generating summary of event...",
      "Generating follow-up of event...",
      "Generating impact analysis of event...",
      "Generating brief of event..."
    ];

    // Function to update the dialog text
    ValueNotifier<String> currentMessage = ValueNotifier(progressMessages[0]);

    // Show loading dialog with dynamic text
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ValueListenableBuilder<String>(
            valueListenable: currentMessage,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    try {
      // Retrieve highlights from image and data
      currentMessage.value = progressMessages[0];
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide the event highlights in paragraph form as plain text.",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _highlightsController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      });

      // Retrieve key takeaways from image and data
      currentMessage.value = progressMessages[1];
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide the event key takeaways in paragraph form as plain text.",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _keyTakeawaysController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      });

      currentMessage.value = progressMessages[2];
      // retrieve summary from image and data
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide the event summary in paragraph form as plain text.",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _summaryController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError(
        (e) {
          log('textAndImageInput', error: e);
        },
      );

      // Retrieve follow-up from image and data
      currentMessage.value = progressMessages[3];
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide what kind of follow up can be done for this event in paragraph form as plain text. Please give me in 50 words",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _followUpController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      });

      // Retrieve impact analysis from image and data
      currentMessage.value = progressMessages[4];
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide impact analysis of event in paragraph form as plain text.",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _impactAnalysisController.text =
            value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      });

      // Retrieve event report brief description
      currentMessage.value = progressMessages[5];
      await gemini.textAndImage(
        text:
            "Refer to the event poster and consider following information: Event type is ${eventTypeValueListenable.value}. Participant type: ${participantTypeValueListenable.value}. Number of participants: ${_noOfParticipantsController.text}. Event description: ${_eventDescriptionGeminiPromptController.text}. Please provide brief description of event report in paragraph which has 1000 words as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _eventDescriptionController.text =
            value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      });
      setState(() {
        _isEventDetailsGenerated = true;
      });
    } catch (e) {
      log('Error in extracting event details', error: e);
    } finally {
      // Close the loading dialog once all operations are complete
      Get.back();
    }
  }

  void extractBasicInformation() async {
    // List of progress messages to show
    List<String> progressMessages = [
      "Extracting School...",
      "Extracting Department...",
      "Extracting title...",
      "Extracting venue...",
      "Extracting date...",
      "Extracting time...",
    ];

    // Function to update the dialog text
    ValueNotifier<String> currentMessage = ValueNotifier(progressMessages[0]);

    // Show loading dialog with dynamic text
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ValueListenableBuilder<String>(
            valueListenable: currentMessage,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    try {
      currentMessage.value = progressMessages[0];

      // Retrieve title from image
      await gemini.textAndImage(
        text:
            "Which school is assosiated with this event? School of Sciences? School of Social Sciences? give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _schoolController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });

      currentMessage.value = progressMessages[1];
      // Retrieve department from image
      await gemini.textAndImage(
        text:
            "Which department is assosiated with this event? Department of Computer Sciences? Department of Mathematics? if not mention, response as 'N/A' give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _departmentController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });

      currentMessage.value = progressMessages[2];

      // Retrieve title from image
      await gemini.textAndImage(
        text: "What is the title of event in image? give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _titleController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });

      // Retrieve venue from image
      currentMessage.value = progressMessages[3];

      await gemini.textAndImage(
        text: "What is the venue of event in image? give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _venueController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });
      // Retrieve date from image
      currentMessage.value = progressMessages[4];
      await gemini.textAndImage(
        text: "What is the date of event in image? give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _dateController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });

      // Retrieve time from image
      currentMessage.value = progressMessages[5];

      await gemini.textAndImage(
        text:
            "What is the only time of event and don't give date of event in image? if time is not mention, give response only as 'N/A'. give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _timeController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
      });

      setState(() {
        _analysisCompleted = true;
        _additionalInformation = true;
      });
    } catch (e) {
      log('Error during Gemini API call', error: e);
    } finally {
      // Hide loading dialog when all operations are complete
      Get.back();
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _departmentController.dispose();
    _typeController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _typeOfParticipantsController.dispose();
    _noOfParticipantsController.dispose();
    _highlightsController.dispose();
    _keyTakeawaysController.dispose();
    _summaryController.dispose();
    _followUpController.dispose();
    _rapporteurNameController.dispose();
    _rapporteurEmailController.dispose();
    _eventDescriptionController.dispose();
    for (var controller in _speakerNameControllers) {
      controller.dispose();
    }
    for (var controller in _speakerPositionControllers) {
      controller.dispose();
    }
    for (var controller in _speakerTitleControllers) {
      controller.dispose();
    }
    for (var controller in _speakerOrganizationControllers) {
      controller.dispose();
    }
    for (var controller in _speakerBioControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSpeaker() {
    setState(() {
      _speakerNameControllers.add(TextEditingController());
      _speakerPositionControllers.add(TextEditingController());
      _speakerTitleControllers.add(TextEditingController());
      _speakerOrganizationControllers.add(TextEditingController());
      _speakerBioControllers.add(TextEditingController());
    });
  }

  void _removeSpeaker(int index) {
    setState(() {
      _speakerNameControllers[index].dispose();
      _speakerPositionControllers[index].dispose();
      _speakerTitleControllers[index].dispose();
      _speakerOrganizationControllers[index].dispose();
      _speakerBioControllers[index].dispose();
      _speakerNameControllers.removeAt(index);
      _speakerPositionControllers.removeAt(index);
      _speakerTitleControllers.removeAt(index);
      _speakerOrganizationControllers.removeAt(index);
      _speakerBioControllers.removeAt(index);
    });
  }

  // Variables to hold the state of the checkboxes
  bool isStudent = false;
  bool isFaculty = false;
  bool isResearchScholar = false;

  // Function to get selected participant types
  List<String> getSelectedParticipantTypes() {
    List<String> selectedTypes = [];
    if (isStudent) selectedTypes.add('Student');
    if (isFaculty) selectedTypes.add('Faculty');
    if (isResearchScholar) selectedTypes.add('Research Scholar');
    return selectedTypes;
  }

  @override
  Widget build(BuildContext context) {
    // final appColors = context.appColors;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(12),
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
            boxShadow: [
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.5), // Shadow color with some transparency
                spreadRadius: 2, // How much the shadow spreads
                blurRadius: 5, // How soft or sharp the shadow is
                offset: const Offset(
                    0, 3), // Position of the shadow (horizontal, vertical)
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Concept & Design by: Dr. Ashok Immanuel V",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    // fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0b3f63),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Mentored by: Dr. Helen K. Joy",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    // fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0b3f63),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Developed by: Riya Shah (2347151) & Vansh Shah (2347152) ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    // fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff0b3f63),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffFFFFFF),
                Color(0xffF5F5DC),
              ],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 280,
                      height: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        // color: Colors.white, // Background color
                        color: const Color(0xffF5F5F5), // Background color
                        borderRadius: BorderRadius.circular(
                            12.0), // Rounded corners (optional)
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                                0.5), // Shadow color with transparency
                            spreadRadius: 5, // How wide the shadow is spread
                            blurRadius: 7, // How soft the shadow is
                            offset: const Offset(
                                0, 3), // Changes position of the shadow (x, y)
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "CU Report Rover",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff0b3f63),
                                ),
                              ),
                              Text(
                                "where events end, effortless reports begin",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff0b3f63),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    // section 2 - Upload poster
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        eventPosterImageUnit8 == null
                            ? ElevatedButton(
                                onPressed: selectPosterImage,
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: const Text("Upload Poster"),
                              )
                            : Center(
                                child: Image.memory(
                                  eventPosterImageUnit8!,
                                  height: height * 0.5,
                                  width: 300,
                                ),
                              ),
                        if (eventPosterImageUnit8 != null)
                          customeSpace(height: 20),
                        if (eventPosterImageUnit8 != null)
                          Center(
                            child: ElevatedButton(
                              // onPressed: extractBasicInformation,
                              onPressed: () {
                                //comment
                                // setState(() {
                                //   _analysisCompleted = true;
                                //   _additionalInformation = true;
                                // });

                                extractBasicInformation();
                              },
                              child: const Text(
                                "Analyze Event Poster",
                              ),
                            ),
                          ),
                        if (eventPosterImageUnit8 != null)
                          customeSpace(height: 20),
                        // section 3 - Basic Information
                        _analysisCompleted
                            ? Container(
                                width: width * 0.9,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "General Details",
                                        style: GoogleFonts.ptSans(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff0b3f63),
                                        ),
                                      ),
                                    ),
                                    customeSpace(height: 12),
                                    Column(
                                      children: [
                                        _buildTextField(
                                          _schoolController,
                                          "School",
                                          false,
                                          "Please enter school name",
                                        ),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        _buildTextField(
                                          _departmentController,
                                          "Department",
                                          false,
                                          "Please enter department name",
                                        ),
                                      ],
                                    ),
                                    // customeSpace(height: 8),
                                    Column(
                                      children: [
                                        _buildTextField(
                                            _titleController,
                                            'Event Title',
                                            false,
                                            "Please enter event title"),
                                        // const SizedBox(
                                        //   height: 8,
                                        // ),
                                        _buildTextField(
                                            _venueController,
                                            'Event Venue',
                                            false,
                                            "Please enter event venue"),
                                      ],
                                    ),
                                    customeSpace(height: 8),
                                    Column(
                                      children: [
                                        buildDateFormField(
                                            context, 'Please select date'),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        buildTimeFormField(
                                            context, 'Please select time'),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        // section 3.1 - Additional Information of Event as input
                        _additionalInformation
                            ? Container(
                                width: width * 0.9,
                                padding: const EdgeInsets.all(12),
                                margin: EdgeInsets.only(top: height * 0.05),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Please provide additional information",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ptSans(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff0b3f63),
                                        ),
                                      ),
                                    ),
                                    customeSpace(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: buildDropdownButtonFormField(
                                            options: events,
                                            selectedValue:
                                                eventTypeValueListenable,
                                            hintText: "Event Type",
                                            validationMessage:
                                                "Please Select event type",
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        Expanded(
                                          child: buildDropdownButtonFormField(
                                            options: eventModes,
                                            selectedValue:
                                                eventModeValueListenable,
                                            hintText: "Event Mode",
                                            validationMessage:
                                                "Please Select event mode",
                                          ),
                                        ),
                                      ],
                                    ),
                                    customeSpace(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF7F7F7),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: Colors.black45,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Participant Type",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xff0b3f63),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            indent: 45,
                                            endIndent: 45,
                                            color: Colors.black45,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: CheckboxListTile(
                                                  title: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "Student",
                                                      style: GoogleFonts.roboto(
                                                        fontSize:
                                                            18, // Base font size (will scale down if needed)
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff0b3f63),
                                                      ),
                                                    ),
                                                  ),
                                                  value: isStudent,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isStudent = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: CheckboxListTile(
                                                  title: FittedBox(
                                                    fit: BoxFit
                                                        .scaleDown, // Ensure text scales down if needed
                                                    child: Text(
                                                      "Faculty",
                                                      style: GoogleFonts.roboto(
                                                        fontSize:
                                                            18, // Base font size (will scale down if needed)
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff0b3f63),
                                                      ),
                                                    ),
                                                  ),
                                                  value: isFaculty,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isFaculty = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: CheckboxListTile(
                                                  title: FittedBox(
                                                    fit: BoxFit
                                                        .scaleDown, // Ensure text scales down if needed
                                                    child: Text(
                                                      "Research Scholar",
                                                      style: GoogleFonts.roboto(
                                                        fontSize:
                                                            18, // Base font size (will scale down if needed)
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xff0b3f63),
                                                      ),
                                                    ),
                                                  ),
                                                  value: isResearchScholar,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isResearchScholar =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    customeSpace(height: 12),
                                    Row(
                                      children: [
                                        // Expanded(
                                        //   child: buildDropdownButtonFormField(
                                        //       options: participants,
                                        //       selectedValue:
                                        //           participantTypeValueListenable,
                                        //       hintText: "Participant type",
                                        //       validationMessage:
                                        //           "please select participant type"),
                                        // ),
                                        // const SizedBox(
                                        //   width: 24,
                                        // ),
                                        Expanded(
                                          child: _buildTextField(
                                              _noOfParticipantsController,
                                              'Number of Participants',
                                              false,
                                              "Please enter number of participants"),
                                        ),
                                      ],
                                    ),
                                    customeSpace(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField(
                                              _eventDescriptionGeminiPromptController,
                                              'Event Description',
                                              true,
                                              "Please enter Event Description"),
                                        ),
                                      ],
                                    ),
                                    customeSpace(
                                      height: 20,
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          extractEventDetails(context);
                                        },
                                        child: const Text(
                                          "Generate Synopsis Information",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        // section 3.2 - Generated Information
                        _isEventDetailsGenerated
                            ? Container(
                                width: width * 0.9,
                                padding: const EdgeInsets.all(12),
                                margin: EdgeInsets.only(top: height * 0.05),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Synopsis Details",
                                        style: GoogleFonts.ptSans(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff0b3f63),
                                        ),
                                      ),
                                    ),
                                    customeSpace(height: 12),
                                    _buildTextField(
                                      _highlightsController,
                                      'Highlights',
                                      true,
                                      "Please add event highlights",
                                    ),
                                    customeSpace(height: 8),
                                    _buildTextField(
                                      _keyTakeawaysController,
                                      'Key Takeaways',
                                      true,
                                      "Please enter key takeaways",
                                    ),
                                    customeSpace(height: 8),
                                    _buildTextField(
                                      _summaryController,
                                      'Summary',
                                      true,
                                      "Please enter event summary",
                                    ),
                                    customeSpace(height: 8),
                                    _buildTextField(
                                      _followUpController,
                                      'Follow-Up',
                                      true,
                                      "Please enter follow-up",
                                    ),
                                    customeSpace(height: 8),
                                    _buildTextField(
                                      _impactAnalysisController,
                                      'Impact Analysis',
                                      true,
                                      "Please add event report brief description",
                                    ),
                                    customeSpace(height: 20),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        // section 4 - Speaker Details and Photos
                        _isEventDetailsGenerated
                            ? Container(
                                width: width * 0.9,
                                padding: const EdgeInsets.all(12),
                                margin: EdgeInsets.only(top: height * 0.05),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "Repporteur Details",
                                        style: GoogleFonts.ptSans(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff0b3f63),
                                        ),
                                      ),
                                    ),
                                    customeSpace(height: 12),
                                    Column(
                                      children: [
                                        _buildTextField(
                                            _rapporteurNameController,
                                            'Rapporteur Name',
                                            false,
                                            "Please add rapporteur name"),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        _buildTextField(
                                            _rapporteurEmailController,
                                            'Rapporteur Email',
                                            false,
                                            "Please add rapporteur email"),
                                      ],
                                    ),
                                    customeSpace(height: 8),
                                    customeSpace(height: 20),
                                    const Divider(),
                                    customeSpace(height: 12),
                                    Center(
                                      child: Text(
                                        "Speaker Details",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    customeSpace(height: 24),
                                    Row(
                                      children: [
                                        ..._buildSpeakerDetails(),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                    customeSpace(height: 16),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: _addSpeaker,
                                        child: const Text('Add Speaker'),
                                      ),
                                    ),
                                    customeSpace(height: 20),
                                    const Divider(),
                                    customeSpace(height: 12),
                                    // all images
                                    Column(
                                      children: [
                                        Column(
                                          children: [
                                            geoTaggedImagesUnit8 == null
                                                ? GestureDetector(
                                                    onTap: selectGeoTaggedImage,
                                                    child: DottedBorder(
                                                      radius:
                                                          const Radius.circular(
                                                              10),
                                                      dashPattern: const [
                                                        10,
                                                        4
                                                      ],
                                                      borderType:
                                                          BorderType.RRect,
                                                      strokeCap:
                                                          StrokeCap.round,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .folder_open_outlined,
                                                              size: 40,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Upload GeoTag Image",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: geoTaggedImagesUnit8 !=
                                                                null &&
                                                            geoTaggedImagesUnit8!
                                                                .isNotEmpty
                                                        ? CarouselSlider(
                                                            options:
                                                                CarouselOptions(
                                                              height:
                                                                  300.0, // Set the height of the carousel
                                                              enlargeCenterPage:
                                                                  true, // Make the currently centered item larger
                                                              enableInfiniteScroll:
                                                                  false, // Disable infinite scrolling
                                                              autoPlay:
                                                                  false, // Disable automatic sliding
                                                            ),
                                                            items: geoTaggedImagesUnit8!
                                                                .map(
                                                                    (imageBytes) {
                                                              return Builder(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Container(
                                                                    width:
                                                                        300, // Set width of each image
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child: Image
                                                                        .memory(
                                                                      imageBytes,
                                                                      fit: BoxFit
                                                                          .cover, // Scale the image to cover the box
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }).toList(),
                                                          )
                                                        : Text(
                                                            "No images selected",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                  ),
                                            customeSpace(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: submitted == true
                                                      ? null
                                                      : clearGeoTaggedImages,
                                                  label: const Text(
                                                    "Clear",
                                                  ),
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Column(
                                          children: [
                                            feedBackAnalysisImageUnit8 == null
                                                ? GestureDetector(
                                                    onTap:
                                                        selectFeedbackFormImages,
                                                    child: DottedBorder(
                                                      radius:
                                                          const Radius.circular(
                                                              10),
                                                      dashPattern: const [
                                                        10,
                                                        4
                                                      ],
                                                      borderType:
                                                          BorderType.RRect,
                                                      strokeCap:
                                                          StrokeCap.round,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 150,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .folder_open_outlined,
                                                              size: 40,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              "Upload Feedback Image",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: feedBackAnalysisImageUnit8 !=
                                                                null &&
                                                            feedBackAnalysisImageUnit8!
                                                                .isNotEmpty
                                                        ? CarouselSlider(
                                                            options:
                                                                CarouselOptions(
                                                              height:
                                                                  300.0, // Set the height of the carousel
                                                              enlargeCenterPage:
                                                                  true, // Make the currently centered item larger
                                                              enableInfiniteScroll:
                                                                  false, // Disable infinite scrolling
                                                              autoPlay:
                                                                  false, // Disable automatic sliding
                                                            ),
                                                            items: feedBackAnalysisImageUnit8!
                                                                .map(
                                                                    (imageBytes) {
                                                              return Builder(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Container(
                                                                    width:
                                                                        300, // Set width of each image
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            5.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child: Image
                                                                        .memory(
                                                                      imageBytes,
                                                                      fit: BoxFit
                                                                          .cover, // Scale the image to cover the box
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            }).toList(),
                                                          )
                                                        : Text(
                                                            "No images selected",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                  ),
                                            customeSpace(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: submitted == true
                                                      ? null
                                                      : clearFeedbackFormImages,
                                                  label: const Text(
                                                    "Clear",
                                                  ),
                                                  icon: const Icon(
                                                      Icons.cancel_outlined),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    customeSpace(height: 32),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              activityImagesUnit8 == null
                                                  ? GestureDetector(
                                                      onTap:
                                                          selectActivityImages,
                                                      child: DottedBorder(
                                                        radius: const Radius
                                                            .circular(10),
                                                        dashPattern: const [
                                                          10,
                                                          4
                                                        ],
                                                        borderType:
                                                            BorderType.RRect,
                                                        strokeCap:
                                                            StrokeCap.round,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            // color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .folder_open_outlined,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Upload Activity Image",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: activityImagesUnit8 !=
                                                                  null &&
                                                              activityImagesUnit8!
                                                                  .isNotEmpty
                                                          ? CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                height:
                                                                    300.0, // Set the height of the carousel
                                                                enlargeCenterPage:
                                                                    true, // Make the currently centered item larger
                                                                enableInfiniteScroll:
                                                                    false, // Disable infinite scrolling
                                                                autoPlay:
                                                                    false, // Disable automatic sliding
                                                              ),
                                                              items: activityImagesUnit8!
                                                                  .map(
                                                                      (imageBytes) {
                                                                return Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                      width:
                                                                          300, // Set width of each image
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child: Image
                                                                          .memory(
                                                                        imageBytes,
                                                                        fit: BoxFit
                                                                            .cover, // Scale the image to cover the box
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }).toList(),
                                                            )
                                                          : Text(
                                                              "No images selected",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                    ),
                                              customeSpace(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: submitted == true
                                                        ? null
                                                        : clearActivityImages,
                                                    label: const Text(
                                                      "Clear",
                                                    ),
                                                    icon: const Icon(
                                                        Icons.cancel_outlined),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    customeSpace(height: 32),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              attendanceImagesUnit8 == null
                                                  ? GestureDetector(
                                                      onTap:
                                                          selectAttendanceImages,
                                                      child: DottedBorder(
                                                        radius: const Radius
                                                            .circular(10),
                                                        dashPattern: const [
                                                          10,
                                                          4
                                                        ],
                                                        borderType:
                                                            BorderType.RRect,
                                                        strokeCap:
                                                            StrokeCap.round,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            // color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .folder_open_outlined,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Upload Attendance Image",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: attendanceImagesUnit8 !=
                                                                  null &&
                                                              attendanceImagesUnit8!
                                                                  .isNotEmpty
                                                          ? CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                height:
                                                                    300.0, // Set the height of the carousel
                                                                enlargeCenterPage:
                                                                    true, // Make the currently centered item larger
                                                                enableInfiniteScroll:
                                                                    false, // Disable infinite scrolling
                                                                autoPlay:
                                                                    false, // Disable automatic sliding
                                                              ),
                                                              items: attendanceImagesUnit8!
                                                                  .map(
                                                                      (imageBytes) {
                                                                return Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                      width:
                                                                          300, // Set width of each image
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child: Image
                                                                          .memory(
                                                                        imageBytes,
                                                                        fit: BoxFit
                                                                            .cover, // Scale the image to cover the box
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }).toList(),
                                                            )
                                                          : Text(
                                                              "No images selected",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                    ),
                                              customeSpace(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: submitted == true
                                                        ? null
                                                        : clearAttendanceImages,
                                                    label: const Text(
                                                      "Clear",
                                                    ),
                                                    icon: const Icon(
                                                        Icons.cancel_outlined),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        customeSpace(height: height * 0.05),
                        _isEventDetailsGenerated
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                width: width * 0.8,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      _generatePdf(context);
                                    } else {
                                      Get.snackbar("Error",
                                          "Please Enter all the details");
                                    }
                                    // _generatePdf(context);
                                  },
                                  child: const Text('Generate PDF'),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List<Widget> _buildSpeakerDetails() {
    List<Widget> widgets = [];
    for (int i = 0; i < _speakerNameControllers.length; i++) {
      widgets.add(Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Speaker ${i + 1} Details',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              _buildTextField(_speakerNameControllers[i], 'Speaker Name', false,
                  "Please add speaker name"),
              _buildTextField(_speakerPositionControllers[i],
                  'Speaker Position', false, "Please add speaker position"),
              _buildTextField(_speakerTitleControllers[i], 'Presentation Title',
                  false, "Please add presentation title"),
              _buildTextField(_speakerOrganizationControllers[i],
                  'Organization', false, "Please add organization"),

              // Speaker Bio section
              const SizedBox(height: 20),
              Text('Speaker ${i + 1} Bio',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (_speakerImages.length > i)
                Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.memory(_speakerImages[i]),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => selectSpeakerImage(i),
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open_outlined,
                            size: 40,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Upload Speaker Image",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              _buildTextField(_speakerBioControllers[i], 'Speaker Bio', true,
                  "Please add speaker bio"),

              // Remove Speaker button
              Center(
                child: ElevatedButton(
                  onPressed: () => _removeSpeaker(i),
                  child: Text('Remove Speaker ${i + 1}'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ));
    }
    return widgets;
  }

  void selectSpeakerImage(int index) async {
    var res = await pickSpeakerImages();
    var convertedImage = await res.readAsBytes();
    setState(() {
      if (_speakerImages.length > index) {
        _speakerImages[index] = convertedImage;
      } else {
        _speakerImages.add(convertedImage);
      }
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    bool maxlines,
    String validationMessage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxlines ? 4 : 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: labelText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          if (value.trim() == "N/A") {
            return validationMessage;
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      _dateController.text = formattedDate; // Update the controller
    }
  }

  TextFormField buildDateFormField(
      BuildContext context, String validationMessage) {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        labelText: 'Date',
        hintText: 'DD-MM-YYYY',
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Rounded corners when not focused
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when not focused
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Rounded corners when focused
          borderSide: const BorderSide(
            color: Colors.black, // Border color when focused
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
      readOnly: true, // Makes the field read-only to prevent manual input
      onTap: () => _selectDate(context), // Opens date picker when tapped
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedDate =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedDate != null) {
      String formattedDate = "${pickedDate.hour}: ${pickedDate.minute}";
      _timeController.text = formattedDate; // Update the controller
    }
  }

  TextFormField buildTimeFormField(
      BuildContext context, String valudaionMessage) {
    return TextFormField(
      controller: _timeController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        labelText: 'Time',
        hintText: 'Hours: minutes',
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Rounded corners when not focused
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when not focused
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12.0), // Rounded corners when focused
          borderSide: const BorderSide(
            color: Colors.black, // Border color when focused
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please Enter event time"; // Corrected the typo here
        }
        return null;
      },
      readOnly: true, // Makes the field read-only to prevent manual input
      onTap: () => _selectTime(context), // Opens time picker when tapped
    );
  }

  Widget buildDropdownButtonFormField({
    required List<String> options,
    required ValueNotifier<String?> selectedValue,
    required String hintText,
    required String validationMessage,
  }) {
    return DropdownButtonFormField2<String>(
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      hint: Text(
        hintText,
        style: const TextStyle(fontSize: 14),
      ),
      items: options
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return validationMessage;
        }
        return null;
      },
      onChanged: (value) {
        selectedValue.value = value;
      },
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget customeSpace({double height = 0, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  pw.TableRow _buildTableRow(
      String label, String value, pw.Font ttf, pw.Font boldTtf) {
    return pw.TableRow(
      children: [
        pw.Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(label,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, font: boldTtf)),
        ),
        pw.Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(font: ttf),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTextBlock(
      String title, String content, pw.Font ttf, pw.Font boldTtf) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: boldTtf, fontSize: 14)),
        pw.SizedBox(height: 8),
        pw.Text(content,
            textAlign: pw.TextAlign.justify, style: pw.TextStyle(font: ttf)),
        pw.SizedBox(height: 16),
      ],
    );
  }

  void _generatePdf(BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final pdf = pw.Document();

// Load the image files
    List<pw.MemoryImage> geoPdfImages =
        []; // List to store the MemoryImages for PDF

    for (var geoTaggedImage in geoTaggedImages) {
      final Uint8List geoImageBytes = await geoTaggedImage.readAsBytes();
      final pw.MemoryImage geoPdfImage = pw.MemoryImage(geoImageBytes);
      geoPdfImages
          .add(geoPdfImage); // Add the converted MemoryImage to the list
    }

    List<pw.MemoryImage> feedbackAnalysisPdfImages = [];
    for (var feedbackAnalysisPdfImage in feedBackAnalysisImages) {
      final Uint8List feedBackAnalysisBytes =
          await feedbackAnalysisPdfImage.readAsBytes();
      final pw.MemoryImage feedbackPdfImage =
          pw.MemoryImage(feedBackAnalysisBytes);
      feedbackAnalysisPdfImages
          .add(feedbackPdfImage); // Add the converted MemoryImage to the list
    }

    List<pw.MemoryImage> activityPdfImages = [];
    for (var activityPdfImage in activityImages) {
      final Uint8List activityImageBytes = await activityPdfImage.readAsBytes();
      final pw.MemoryImage activityPdf = pw.MemoryImage(activityImageBytes);
      activityPdfImages
          .add(activityPdf); // Add the converted MemoryImage to the list
    }

    List<pw.MemoryImage> attendancePdfImages = [];
    for (var attendencePdfImage in attendanceImages) {
      final Uint8List attendenceImagesBytes =
          await attendencePdfImage.readAsBytes();
      final pw.MemoryImage attendencePdf =
          pw.MemoryImage(attendenceImagesBytes);
      attendancePdfImages
          .add(attendencePdf); // Add the converted MemoryImage to the list
    }

    final Uint8List posterImageBytes = await eventPosterImage.readAsBytes();
    final pw.MemoryImage posterPdfImage = pw.MemoryImage(posterImageBytes);

    final selectedTypes = getSelectedParticipantTypes();
    final selectedType = selectedTypes.join(', ');

    final ttf = pw.Font.ttf(await rootBundle.load("fonts/georgia.ttf"));
    final boldTtf = pw.Font.ttf(await rootBundle.load("fonts/georgiab.ttf"));
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(_schoolController.text,
                      style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(_departmentController.text,
                      style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text('CHRIST (Deemed to be University), Bangalore',
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Text('Activity Report',
                      style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: height * 0.02),
            pw.Text('General Information',
                style: pw.TextStyle(font: boldTtf, fontSize: 14)),
            pw.SizedBox(height: height * 0.01),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow('Type of Activity',
                    eventTypeValueListenable.value!, ttf, boldTtf),
                _buildTableRow('Title of the Activity', _titleController.text,
                    ttf, boldTtf),
                _buildTableRow('Date/s', _dateController.text, ttf, boldTtf),
                _buildTableRow('Time', _timeController.text, ttf, boldTtf),
                _buildTableRow('Venue', _venueController.text, ttf, boldTtf),
                _buildTableRow(
                    'Mode', eventModeValueListenable.value!, ttf, boldTtf),
              ],
            ),
            pw.SizedBox(height: height * 0.02),
            _speakerNameControllers.isEmpty
                ? pw.SizedBox()
                : pw.Text('Speaker/Guest/Presenter Details',
                    style: pw.TextStyle(font: boldTtf, fontSize: 14)),
            _speakerNameControllers.isEmpty
                ? pw.SizedBox()
                : pw.SizedBox(height: height * 0.02),
            ..._buildSpeakerDetailsPdf(ttf, boldTtf),
            pw.SizedBox(height: height * 0.02),
            pw.Text('Participants Profile',
                style: pw.TextStyle(font: boldTtf, fontSize: 14)),
            pw.SizedBox(height: height * 0.01),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow(
                    'Type of Participants', selectedType, ttf, boldTtf),
                _buildTableRow('No. of Participants',
                    _noOfParticipantsController.text, ttf, boldTtf),
              ],
            ),
            pw.SizedBox(height: height * 0.02),
            pw.Text('Synopsis of the Activity (Description)',
                style: pw.TextStyle(font: boldTtf, fontSize: 14)),
            pw.SizedBox(height: height * 0.02),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow('Highlights of Activity',
                    _highlightsController.text, ttf, boldTtf),
                _buildTableRow('Key Takeaways', _keyTakeawaysController.text,
                    ttf, boldTtf),
                _buildTableRow('Summary Of Activity', _summaryController.text,
                    ttf, boldTtf),
                _buildTableRow('Follow-up Plan, if any',
                    _followUpController.text, ttf, boldTtf),
                _buildTableRow('Impact Analysis',
                    _impactAnalysisController.text, ttf, boldTtf)
              ],
            ),
            pw.SizedBox(height: height * 0.03),
            pw.Text('Rapporteur',
                style: pw.TextStyle(font: boldTtf, fontSize: 14)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow('Rapporteur Name',
                    _rapporteurNameController.text, ttf, boldTtf),
                _buildTableRow('Rapporteur Email',
                    _rapporteurEmailController.text, ttf, boldTtf),
              ],
            ),
          ];
        },
        footer: (pw.Context context) {
          return pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: pw.Text('Generated by Report Rover-v1.0',
                style: pw.TextStyle(
                    font: ttf,
                    fontSize: 8,
                    color: const PdfColor(0.7, 0.7, 0.7))),
          );
        },
      ),
    );
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildTextBlock('Event Report',
                        _eventDescriptionController.text, ttf, boldTtf),
                    _speakerNameControllers.isEmpty
                        ? pw.SizedBox()
                        : pw.Text('Speakers Profile',
                            style: pw.TextStyle(font: boldTtf, fontSize: 14)),
                    pw.SizedBox(height: 8),
                    for (int i = 0; i < _speakerBioControllers.length; i++)
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: double.infinity,
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Image(pw.MemoryImage(_speakerImages[i]),
                                    height: 150, width: 150),
                                pw.SizedBox(width: width * 0.05),
                                pw.Expanded(
                                  child: pw.Text(_speakerBioControllers[i].text,
                                      textAlign: pw.TextAlign.justify),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              pw.Positioned(
                bottom: 20,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

    // Page for Geo Tagged Images
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Geo Tagged Images',
                        style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 12),

                    // Dynamically display geo-tagged images
                    ...geoPdfImages.map((geoPdfImage) => pw.Center(
                          child: pw.Container(
                            margin:
                                const pw.EdgeInsetsDirectional.only(top: 20),
                            height: 300,
                            width: double.infinity,
                            child: pw.Image(
                              geoPdfImage,
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              // Footer at bottom-right
              pw.Positioned(
                bottom: 20,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

// Page for Activity Images
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Activity Images',
                        style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 12),

                    // Dynamically display activity images
                    ...activityPdfImages.map((activityPdfImage) => pw.Center(
                          child: pw.Container(
                            margin:
                                const pw.EdgeInsetsDirectional.only(top: 20),
                            height: 300,
                            width: double.infinity,
                            child: pw.Image(
                              activityPdfImage,
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              // Footer at bottom-right
              pw.Positioned(
                bottom: 0,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

// Page for Attendance Images
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Attendance Images',
                        style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 12),

                    // Dynamically display attendance images
                    ...attendancePdfImages
                        .map((attendancePdfImage) => pw.Center(
                              child: pw.Container(
                                margin: const pw.EdgeInsetsDirectional.only(
                                    top: 20),
                                height: 300,
                                width: double.infinity,
                                child: pw.Image(
                                  attendancePdfImage,
                                  fit: pw.BoxFit.fill,
                                ),
                              ),
                            )),
                  ],
                ),
              ),
              // Footer at bottom-right
              pw.Positioned(
                bottom: 0,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

// Page for Feedback Form Image
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Feedback Form Images',
                        style: pw.TextStyle(
                          font: boldTtf,
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 12),

                    // Dynamically display feedback form images
                    ...feedbackAnalysisPdfImages
                        .map((feedbackPdfImage) => pw.Center(
                              child: pw.Container(
                                margin: const pw.EdgeInsetsDirectional.only(
                                    top: 20),
                                height: 300,
                                width: double.infinity,
                                child: pw.Image(
                                  feedbackPdfImage,
                                  fit: pw.BoxFit.fill,
                                ),
                              ),
                            )),
                  ],
                ),
              ),
              // Footer at bottom-right
              pw.Positioned(
                bottom: 0,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

// Page for Event Poster
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Column(
                children: [
                  pw.Text('Event Poster',
                      textAlign: pw.TextAlign.start,
                      style: pw.TextStyle(
                        font: boldTtf,
                        fontSize: 14,
                      )),
                  pw.SizedBox(height: 12),
                  pw.Center(
                      child: pw.SizedBox(
                    height: 600,
                    width: 500,
                    child: pw.Image(
                      fit: pw.BoxFit.fill,
                      posterPdfImage,
                    ),
                  )),
                ],
              ),
              // Footer at bottom-right
              pw.Positioned(
                bottom: 0,
                right: 20,
                child: pw.Text('Generated by Report Rover-v1.0',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 8,
                        color: const PdfColor(0.7, 0.7, 0.7))),
              ),
            ],
          );
        },
      ),
    );

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor:
                Colors.transparent, // Transparent background for the dialog
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.all(20.0), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                      0.9), // Slightly transparent white background
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(), // Loading indicator
                    SizedBox(height: 20), // Space between indicator and text
                    Text(
                      "Creating PDF...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Text color
                      ),
                      textAlign: TextAlign.center, // Center-align the text
                    ), // Text below the loader
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Add a 5-second delay after PDF creation
      await Future.delayed(const Duration(seconds: 2));

      // Perform the PDF layout operation
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      // Close the dialog after successful PDF creation
      Get.back(); // This will close the dialog
    } catch (e) {
      Get.back(); // Close the dialog
      Get.snackbar("Error", e.toString());
    }
  }
}
