import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:docx_template/docx_template.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<DataRow> _rows = [];
  TextEditingController analysisController = TextEditingController();
  TextEditingController actionController = TextEditingController();

  String _graphUrl = '';
  Map<String, List<String>> _equipmentImages = {}; // Adjust type

  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchGraphImage();
    fetchEquipmentImages();
    //.then((_) {
    //   // After _fetchGraphImage completes, execute fetchEquipmentImages
    //   fetchEquipmentImages().then((images) {
    //     setState(() {
    //       _equipmentImages = images;
    //     });
    //   }).catchError((error) {
    //     print(error);
    //   });
    // });
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/report_data'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _populateRows(jsonData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _populateRows(Map<String, dynamic> jsonData) {
    List<String> faultData = List<String>.from(jsonData['Fault Data']);
    List<int> numberOfFaults = List<int>.from(jsonData['Number of Faults']);

    _rows = List.generate(faultData.length, (index) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              faultData[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataCell(
            Text(
              numberOfFaults[index].toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      );
    });
    setState(() {});
  }

  Future<void> _fetchGraphImage() async {
    // Make HTTP GET request to Flask endpoint
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/systems_graph'));
    if (response.statusCode == 200) {
      // If request is successful, extract image path from response
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _graphUrl = data['image_path'];
      });
    } else {
      // Handle error
      print('Failed to load graph image: ${response.statusCode}');
    }
  }

  Future<Map<String, List<String>>> fetchEquipmentImages() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/equipment_graph'));

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(response.body);

      // Extract image paths from the decoded JSON
      List<String> imagePaths = List<String>.from(decodedJson['image_paths']);

      // Create a map with the key 'image_paths' and the list of paths as its value
      Map<String, List<String>> equipmentImages = {'image_paths': imagePaths};

      // Print decoded JSON for debugging
      print('Decoded JSON: $equipmentImages');

      return equipmentImages;
    } else {
      throw Exception('Failed to load equipment images');
    }
  }

  // void _generateReport() async {
  //   try {
  //     // Read template bytes
  //     final templateBytes = await File('assets/template.docx').readAsBytes();

  //     // Create a DocxTemplate instance from the template file
  //     final template = await DocxTemplate.fromBytes(templateBytes);

  //     // Prepare data to fill placeholders in the template
  //     final Map<String, dynamic> data = {
  //       'wheelAnalysis': analysisController.text,
  //       'actionPoints': actionController.text,
  //     };

  //     // Generate the report
  //     final List<int> reportBytes = (await template.generate(data))!;

  //     // Save the report as a Word file
  //     final reportFile = File('report.docx');
  //     await reportFile.writeAsBytes(reportBytes);

  //     // Provide feedback to the user or open the file
  //     print('Report generated successfully!');
  //   } catch (e) {
  //     print('Error generating report: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 720,
            width: 1370,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/background.png'),
              ),
            ),
          ),
          Center(
            // Wrap the Container with Center widget
            child: Container(
              margin: EdgeInsets.only(left: 50, top: 50),
              width: 700,
              height: 2500,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF313134),
                borderRadius: BorderRadius.circular(8.2151851654),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: Text(
                        'Weekly Analysis and Reporting',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          // Add functionality for Generate Report button

                          child: Text('Generate Report'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          // Add functionality for View Report button

                          child: Text('View Report'),
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            12), // Adding some space between buttons and text
                    Text(
                      'Get the Weekly Analysis Report',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF),
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      'Fault Data',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    SizedBox(
                        height:
                            30), // Adding some space between buttons and DataTable
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white), // Add border
                      ),
                      child: DataTable(
                        dividerThickness:
                            2, // Thickness of the vertical divider
                        columns: [
                          DataColumn(label: Text('Fault Data')),
                          DataColumn(label: Text('Number of Faults')),
                        ],
                        rows: _rows,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Systems',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    Image(
                      image: AssetImage(
                          'assets/systems.png'), // Load image from assets
                      height: 500, // Adjust height as needed
                      width: 500, // Adjust width as needed
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Equipments',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage('assets/Lightning.png'),
                          height: 500,
                          width: 500,
                        ),
                        Image(
                          image: AssetImage('assets/FAS.png'),
                          height: 500,
                          width: 500,
                        ),
                        Image(
                          image: AssetImage('assets/PIS.png'),
                          height: 500,
                          width: 500,
                        ),
                        Image(
                          image: AssetImage('assets/Interior.png'),
                          height: 500,
                          width: 500,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Wheel Analysis',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 550,
                            height: 80,
                            child: TextField(
                              maxLines: 6,
                              controller: analysisController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the text color to black
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add Major Wheel Analysis',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xddff8518),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xddff8518),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Action points',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 550,
                            height: 80,
                            child: TextField(
                              maxLines: 6,
                              controller: actionController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the text color to black
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Add Major Wheel Analysis Action Points',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xddff8518),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xddff8518),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReportScreen(),
  ));
}
