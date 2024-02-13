import 'package:flutter/material.dart';
import 'dart:convert';
// Import the Uint8List type.
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page3(),
    );
  }
}

class Page3 extends StatefulWidget {
  final String? path;

  Page3({Key? key, this.path}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  TextEditingController FaultInputController = TextEditingController();
  TextEditingController FaultSolutionController = TextEditingController();

  Future<void> getFaultSolution(String faultDescription) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/extract_fault_solution'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_entry_text': faultDescription}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final faultSolutions = data['fault_solutions'];

      // Update the FaultSolutionController text field with the obtained fault solutions
      FaultSolutionController.text = faultSolutions.join('\n');
    } else {
      // Handle error, you can show a snackbar or display an error message
      print('Failed to get fault solutions: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 720,
        width: 1370,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/background.png'),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 250,
              top: 70,
              child: Container(
                width: 900,
                height: 600,
                decoration: BoxDecoration(
                  color: Color(0xFF313134),
                  borderRadius: BorderRadius.circular(20.2151851654),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 45, 0, 25),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 26.2151851654,
                            fontWeight: FontWeight.w400,
                            height: 1.2125,
                            color: Color(0xFFFFFFFF),
                          ),
                          children: [
                            TextSpan(
                              text: 'Fault Detection',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 35,
                                fontWeight: FontWeight.normal,
                                height: 1.2125,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            TextSpan(text: ' '),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // Container(
                        //   margin: EdgeInsets.fromLTRB(55, 0, 0, 0.10),
                        //   width: 280,
                        //   height: 8,
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFF222229),
                        //   ),
                        // ),
                        Container(
                          // No margin for the second Container
                          margin: EdgeInsets.fromLTRB(55, 0, 0, 0.10),
                          width: 500,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xddff8518),
                          ),
                        ),
                        Container(
                          // No margin for the second Container
                          width: 200,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xddff8518),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            'Fault Description',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 650,
                            height: 80,
                            child: TextField(
                              maxLines: 6,
                              controller: FaultInputController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the text color to black
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add Fault description',
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
                              onEditingComplete: () {
                                // Call the function to get fault solutions
                                getFaultSolution(FaultInputController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            'Fault Solution',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 650,
                            height: 80,
                            child: TextField(
                              maxLines: 6,
                              controller: FaultSolutionController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color:
                                    Colors.white, // Set the text color to black
                              ),
                              decoration: InputDecoration(
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
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xddff8518), // Replace with your desired color
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white, // Icon color
                  onPressed: () {
                    // Navigate back when the back button is pressed
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
