import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:report/theme/theme_ext.dart';

class ReportForm extends StatefulWidget {
  static const String routeName = '/event-report-screen';
  const ReportForm({super.key});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final gemini = Gemini.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _impactAnalysisController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
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

  XFile geoTaggedImage = XFile("");
  Uint8List? geoTaggedImageUnit8;
  XFile feedBackFormImage = XFile("");
  Uint8List? feedBackFormImageUnit8;
  XFile activityImage = XFile("");
  Uint8List? activityImageUnit8;
  XFile eventPosterImage = XFile("");
  Uint8List? eventPosterImageUnit8;
  // speaker images
  final List<Uint8List> _speakerImages = [];
  XFile speakerImage = XFile("");
  // File eventPoster = File("");
  final List<Uint8List> _eventPosterForGemini = [];

  bool submitted = false;

  final departmentValueListenable = ValueNotifier<String?>(null);
  List<String> departments = [
    'Department of Computer Science',
    'Department of Mathematics',
    'Department of Social Science',
    'Department of Physics',
    'Department of Chemistry',
    'Department of Life Science',
  ];

  final schoolValueListenable = ValueNotifier<String?>(null);
  List<String> schools = [
    'School of Science',
    'School of Commerce',
    'School of Social Science',
    "School of Architecture",
    "School of Arts and Humanities",
    "School of Business and Management",
    "School of Commerce, Finance and Accountancy",
    "School of Education",
    "School of Engineering and Technology",
    "School of Law",
    "School of Psychological Sciences",
    "School of Sciences",
    "School of Social Sciences",
  ];

  // Workshop/Seminar/Conference/Training/Events
  final eventTypeValueListenable = ValueNotifier<String?>(null);
  List<String> events = [
    "Workshop",
    "Seminar",
    "Conference",
    "Training",
    "Events",
  ];

  //Student/Faculty/Research Scholar
  final participantTypeValueListenable = ValueNotifier<String?>(null);
  List<String> participants = [
    "Student",
    "Faculty",
    "Research Scholar",
  ];

  void selectGeoTaggedImage() async {
    var res = await pickGeoTaggedImages();
    var convertedImage = await res.readAsBytes();
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

  void selectFeedbackFormImage() async {
    var res = await pickFeebackFormImages();
    var convertedImage = await res.readAsBytes();

    setState(() {
      feedBackFormImage = res;
      feedBackFormImageUnit8 = convertedImage;
    });
  }

  void clearFeedbackFormImage() {
    setState(() {
      feedBackFormImage = XFile("");
      feedBackFormImageUnit8 = null;
    });
  }

  Future<XFile> pickFeebackFormImages() async {
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

  void selectActivityImage() async {
    var res = await pickActivityImages();
    var convertedImage = await res.readAsBytes();

    setState(() {
      activityImage = res;
      activityImageUnit8 = convertedImage;
    });
  }

  void clearActivityImage() {
    setState(() {
      activityImage = XFile("");
      activityImageUnit8 = null;
    });
  }

  Future<XFile> pickActivityImages() async {
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

  void selectPosterImage() async {
    var res = await eventPostersImage();
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
    print(image);
    return image;
  }

  List<pw.Widget> _buildSpeakerDetailsPdf() {
    List<pw.Widget> widgets = [];

    for (int i = 0; i < _speakerNameControllers.length; i++) {
      widgets.add(pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Speaker ${i + 1} Details',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              _buildTableRow('Name', _speakerNameControllers[i].text),
              _buildTableRow(
                  'Title/Position', _speakerPositionControllers[i].text),
              _buildTableRow(
                  'Organization', _speakerOrganizationControllers[i].text),
              _buildTableRow(
                  'Title of Presentation', _speakerTitleControllers[i].text),
            ],
          ),
          pw.SizedBox(
            height: 12,
          ),
        ],
      ));
    }
    return widgets;
  }

  void extractEventDetails(BuildContext context) async {
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
    } catch (e) {
      log('Error in extracting event details', error: e);
    } finally {
      // Close the loading dialog once all operations are complete
      Get.back();
    }
  }

  void extractBasicInformation() async {
    // Show loading dialog at the start
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Makes the dialog background transparent
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Light background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(), // Loading indicator
                SizedBox(height: 20), // Space between the indicator and text
                Text(
                  "Analyzing event poster...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Text color
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
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
      await gemini.textAndImage(
        text:
            "What is the only time of event and don't give date of event in image? give answer as plain text",
        images: [_eventPosterForGemini.first],
      ).then((value) {
        _timeController.text = value?.content?.parts?.first.text ?? '';
        log(value?.content?.parts?.last.text ?? '');
      }).catchError((e) {
        log('textAndImageInput', error: e);
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

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.primary,
        title: const Text('CU Report Rover'),
        elevation: 14,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: appColors.white),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffebf4f5),
                Color(0xffb5c6e0),
              ],
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // add event poster
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          eventPosterImageUnit8 == null
                              ? GestureDetector(
                                  onTap: selectPosterImage,
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.folder_open_outlined,
                                            size: 40,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Upload Event Poster",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                    eventPosterImageUnit8!,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                          customeSpace(height: 12),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     SizedBox(
                          //       height: 44,
                          //       width: 224,
                          //       child: ElevatedButton.icon(
                          //         onPressed: submitted == true
                          //             ? null
                          //             : clearPosterImage,
                          //         label: const Text(
                          //           "Clear",
                          //         ),
                          //         icon: const Icon(Icons.cancel_outlined),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                customeSpace(height: 12),
                if (eventPosterImageUnit8 != null)
                  Center(
                    child: ElevatedButton(
                      onPressed: extractBasicInformation,
                      child: const Text(
                        "Analyze Event Poster",
                      ),
                    ),
                  ),
                customeSpace(height: 20),
                const Divider(),
                Center(
                  child: Text(
                    "General Details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                customeSpace(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: buildDropdownButtonFormField(
                          options: schools,
                          selectedValue: schoolValueListenable,
                          hintText: "Select School",
                          validationMessage: "Please select your school"),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: buildDropdownButtonFormField(
                          options: departments,
                          selectedValue: departmentValueListenable,
                          hintText: "Select Department",
                          validationMessage: "Please select your department"),
                    ),
                  ],
                ),

                customeSpace(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_titleController, 'Event Title',
                          false, "Please enter event title"),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: _buildTextField(_venueController, 'Event Venue',
                          false, "Please enter event venue"),
                    ),
                  ],
                ),
                customeSpace(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: buildDateFormField(context, 'Please select date'),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: buildTimeFormField(context, 'Please select time'),
                    ),
                  ],
                ),
                customeSpace(height: 20),
                Center(
                  child: Text(
                    "Event Details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                customeSpace(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: buildDropdownButtonFormField(
                        options: events,
                        selectedValue: eventTypeValueListenable,
                        hintText: "Select Event Type",
                        validationMessage: "Please Select event type",
                      ),
                    ),
                  ],
                ),

                customeSpace(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: buildDropdownButtonFormField(
                          options: participants,
                          selectedValue: participantTypeValueListenable,
                          hintText: "Select participant type",
                          validationMessage: "please select participant type"),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
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
                const Divider(),
                customeSpace(
                  height: 12,
                ),
                Center(
                  child: Text(
                    "Synopsis Details",
                    style: Theme.of(context).textTheme.titleLarge,
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
                const Divider(),
                customeSpace(height: 12),
                Center(
                  child: Text(
                    "Repporteur Details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                customeSpace(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          _rapporteurNameController,
                          'Rapporteur Name',
                          false,
                          "Please add rapporteur name"),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: _buildTextField(
                          _rapporteurEmailController,
                          'Rapporteur Email',
                          false,
                          "Please add rapporteur email"),
                    ),
                  ],
                ),
                customeSpace(height: 8),
                customeSpace(height: 20),
                const Divider(),
                customeSpace(height: 12),
                Center(
                  child: Text(
                    "Speaker Details",
                    style: Theme.of(context).textTheme.titleLarge,
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          geoTaggedImageUnit8 == null
                              ? GestureDetector(
                                  onTap: selectGeoTaggedImage,
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.folder_open_outlined,
                                            size: 40,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Upload GeoTag Image",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                    geoTaggedImageUnit8!,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                          customeSpace(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: submitted == true
                                    ? null
                                    : clearGeoTaggedImage,
                                label: const Text(
                                  "Clear",
                                ),
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          feedBackFormImageUnit8 == null
                              ? GestureDetector(
                                  onTap: selectFeedbackFormImage,
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.folder_open_outlined,
                                            size: 40,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Upload Feedback Image",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                    feedBackFormImageUnit8!,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                          customeSpace(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: submitted == true
                                    ? null
                                    : clearFeedbackFormImage,
                                label: const Text(
                                  "Clear",
                                ),
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          activityImageUnit8 == null
                              ? GestureDetector(
                                  onTap: selectActivityImage,
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.folder_open_outlined,
                                            size: 40,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Upload Activity Image",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                    activityImageUnit8!,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                          customeSpace(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: submitted == true
                                    ? null
                                    : clearActivityImage,
                                label: const Text(
                                  "Clear",
                                ),
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          eventPosterImageUnit8 == null
                              ? GestureDetector(
                                  onTap: selectPosterImage,
                                  child: DottedBorder(
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.folder_open_outlined,
                                            size: 40,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Upload Event Poster",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.memory(
                                    eventPosterImageUnit8!,
                                    height: 300,
                                    width: 300,
                                  ),
                                ),
                          customeSpace(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    submitted == true ? null : clearPosterImage,
                                label: const Text(
                                  "Clear",
                                ),
                                icon: const Icon(Icons.cancel_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please fill all the required fields",
                            ),
                          ),
                        );
                      }
                      // _generatePdf(context);
                    },
                    child: const Text('Generate Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter Date',
        hintText: 'DD-MM-YYYY',
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter Time',
        hintText: 'Hours: minutes',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return valudaionMessage;
        }
        return null;
      },
      readOnly: true, // Makes the field read-only to prevent manual input
      onTap: () => _selectTime(context), // Opens date picker when tapped
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

  pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(value, textAlign: pw.TextAlign.justify),
        ),
      ],
    );
  }

  pw.Widget _buildTextBlock(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text(content, textAlign: pw.TextAlign.justify),
        pw.SizedBox(height: 16),
      ],
    );
  }

  void _generatePdf(BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final pdf = pw.Document();

    // Load the image file
    final Uint8List geoImageBytes = await geoTaggedImage.readAsBytes();
    final pw.MemoryImage geoPdfImage = pw.MemoryImage(geoImageBytes);

    final Uint8List feedbackImageBytes = await feedBackFormImage.readAsBytes();
    final pw.MemoryImage feedbackPdfImage = pw.MemoryImage(feedbackImageBytes);

    final Uint8List activityImageBytes = await activityImage.readAsBytes();
    final pw.MemoryImage activityPdfImage = pw.MemoryImage(activityImageBytes);

    final Uint8List posterImageBytes = await eventPosterImage.readAsBytes();
    final pw.MemoryImage posterPdfImage = pw.MemoryImage(posterImageBytes);

    // Update with actual image URL
    // final String imageUrl = eventReport.poster; NOTE: Commented

    // Download the image
    // final Uint8List posterImageBytes = await _downloadImage(imageUrl); NOTE: Commented
    // final pw.MemoryImage posterPdfImage = pw.MemoryImage(posterImageBytes); NOTE: Commented

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(schoolValueListenable.value!,
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text(departmentValueListenable.value!,
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('CHRIST (Deemed to be University), Bangalore',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Text('Activity Report',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
            pw.SizedBox(height: height * 0.02),
            pw.Text('General Information',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: height * 0.01),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow(
                  'Type of Activity',
                  eventTypeValueListenable.value!,
                ),
                _buildTableRow('Title of the Activity', _titleController.text),
                _buildTableRow('Date/s', _dateController.text),
                _buildTableRow('Time', _timeController.text),
                _buildTableRow('Venue', _venueController.text),
              ],
            ),
            pw.SizedBox(height: height * 0.02),
            _speakerNameControllers.isEmpty
                ? pw.SizedBox()
                : pw.Text('Speaker/Guest/Presenter Details',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
            _speakerNameControllers.isEmpty
                ? pw.SizedBox()
                : pw.SizedBox(height: height * 0.02),
            ..._buildSpeakerDetailsPdf(),
            pw.SizedBox(height: height * 0.02),
            pw.Text('Participants Profile',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: height * 0.01),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow('Type of Participants',
                    participantTypeValueListenable.value!),
                _buildTableRow(
                    'No. of Participants', _noOfParticipantsController.text),
              ],
            ),
            pw.SizedBox(height: height * 0.02),
            pw.Text('Synopsis of the Activity (Description)',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: height * 0.02),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow(
                    'Highlights of Activity', _highlightsController.text),
                _buildTableRow('Key Takeaways', _keyTakeawaysController.text),
                _buildTableRow('Summary Of Activity', _summaryController.text),
                _buildTableRow(
                    'Follow-up Plan, if any', _followUpController.text),
                _buildTableRow(
                    'Impact Analysis', _impactAnalysisController.text)
              ],
            ),
            pw.SizedBox(height: height * 0.03),
            pw.Text('Rapporteur',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                _buildTableRow(
                    'Rapporteur Name', _rapporteurNameController.text),
                _buildTableRow(
                    'Rapporteur Email', _rapporteurEmailController.text),
              ],
            ),
          ];
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildTextBlock(
                    'Event Report', _eventDescriptionController.text),
                _speakerNameControllers.isEmpty
                    ? pw.SizedBox()
                    : pw.Text('Speakers Profile',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
                      )
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );

// New page for Geo Tagged Image
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Geo Tagged Image',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 12),
                pw.Center(
                    child: pw.SizedBox(
                  height: 350,
                  width: 500,
                  child: pw.Image(
                    fit: pw.BoxFit.fill,
                    geoPdfImage,
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );

    // New page for Feedback Form Image
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('FeedBack Form Image',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Center(
                  child: pw.SizedBox(
                height: 350,
                width: 500,
                child: pw.Image(
                  fit: pw.BoxFit.fill,
                  feedbackPdfImage,
                ),
              )),
            ],
          );
        },
      ),
    );

    // New page for Activity Image
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Activity Image',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Center(
                  child: pw.SizedBox(
                height: 350,
                width: 500,
                child: pw.Image(
                  fit: pw.BoxFit.fill,
                  activityPdfImage,
                ),
              )),
            ],
          );
        },
      ),
    );

    // New page for Event Poster
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Event Poster',
                  textAlign: pw.TextAlign.start,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
