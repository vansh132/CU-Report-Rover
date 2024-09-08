import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportForm extends StatefulWidget {
  static const String routeName = '/event-report-screen';
  const ReportForm({super.key});

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final TextEditingController _dateController = TextEditingController();

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

  // Future<Uint8List> _downloadImage(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     throw Exception('Failed to load image');
  //   }
  // }

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
            pw.Text('Speaker/Guest/Presenter Details',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: height * 0.02),
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
            pw.SizedBox(height: height * 0.02),
            _buildTextBlock('Event Report', _eventDescriptionController.text),
            pw.Text('Speakers Profile',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
            pw.Text('Geo Tagged Image',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Center(
              child: pw.Image(geoPdfImage,
                  height: height * 0.3, width: width * 0.95),
            ),
            pw.SizedBox(height: 20),
            pw.Text('FeedBack Form Image',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Center(
                child: pw.Image(feedbackPdfImage,
                    height: height * 0.3, width: width * 0.95)),
            pw.SizedBox(height: 20),
            pw.Text('Activity Image',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Center(
                child: pw.Image(activityPdfImage,
                    height: height * 0.3, width: width * 0.95)),
            pw.SizedBox(height: 20),
            pw.Text('Event Poster',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Image(posterPdfImage),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('CU Report Rover'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: buildDropdownButtonFormField(
                      options: departments,
                      selectedValue: departmentValueListenable,
                      hintText: "Select Department",
                      validationMessage: "Please select your department"),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: buildDropdownButtonFormField(
                      options: schools,
                      selectedValue: schoolValueListenable,
                      hintText: "Select School",
                      validationMessage: "Please select your school"),
                ),
              ],
            ),
            const Divider(
              height: 24,
            ),
            customeSpace(),
            const Center(child: Text("General Details")),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _titleController,
                    'Event Title',
                    false,
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                    child: _buildTextField(
                        _venueController, 'Event Venue', false)),
              ],
            ),
            customeSpace(),
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
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: buildDateFormField(context),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: buildTimeFormField(context),
                ),
              ],
            ),
            // _buildTextField(_typeController, 'Event Type', false),
            // _buildTextField(_dateController, 'Event Date', false),
            // _buildTextField(_timeController, 'Event Time', false),
            customeSpace(),

            const Center(child: Text("Participant Details")),
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
                  child: _buildTextField(_noOfParticipantsController,
                      'Number of Participants', false),
                ),
              ],
            ),
            customeSpace(),

            const Center(child: Text("Synopsis Details")),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      _highlightsController, 'Event Highlights', true),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: _buildTextField(
                        _keyTakeawaysController, 'Key Takeaways', true)),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: _buildTextField(
                        _summaryController, 'Event Summary', true)),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                    child: _buildTextField(
                        _followUpController, 'Follow-Up', true)),
              ],
            ),
            customeSpace(),

            const Center(child: Text("Repporteur Details")),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      _rapporteurNameController, 'Rapporteur Name', false),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: _buildTextField(
                      _rapporteurEmailController, 'Rapporteur Email', false),
                ),
              ],
            ),
            _buildTextField(
              _eventDescriptionController,
              'Event Report Brief Description',
              true,
            ),
            customeSpace(),
            Row(
              children: [
                ..._buildSpeakerDetails(),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),

            Center(
              child: ElevatedButton(
                onPressed: _addSpeaker,
                child: const Text('Add Speaker'),
              ),
            ),
            customeSpace(),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Image.memory(geoTaggedImageUnit8!),
                            ),
                      customeSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                submitted == true ? null : clearGeoTaggedImage,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Image.memory(feedBackFormImageUnit8!),
                            ),
                      customeSpace(),
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
            customeSpace(),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Image.memory(activityImageUnit8!),
                            ),
                      customeSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                submitted == true ? null : clearActivityImage,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Image.memory(eventPosterImageUnit8!),
                            ),
                      customeSpace(),
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
                onPressed: () {
                  _generatePdf(context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
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
              _buildTextField(
                  _speakerNameControllers[i], 'Speaker Name', false),
              _buildTextField(
                  _speakerPositionControllers[i], 'Speaker Position', false),
              _buildTextField(
                  _speakerTitleControllers[i], 'Presentation Title', false),
              _buildTextField(
                  _speakerOrganizationControllers[i], 'Organization', false),

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
              _buildTextField(_speakerBioControllers[i], 'Speaker Bio', true),

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
      TextEditingController controller, String labelText, bool maxlines) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxlines ? 4 : 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: labelText,
        ),
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

  TextFormField buildDateFormField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter Date',
        hintText: 'DD-MM-YYYY',
      ),

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

  TextFormField buildTimeFormField(BuildContext context) {
    return TextFormField(
      controller: _timeController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter Time',
        hintText: 'Hours: minutes',
      ),

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
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget customeSpace() {
    return const Gap(20);
  }
}
