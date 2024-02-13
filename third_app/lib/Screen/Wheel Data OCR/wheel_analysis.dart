import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:third_app/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WheelAnalysis(),
    );
  }
}

//import 'app_data.dart';
class WheelAnalysis extends StatefulWidget {
  const WheelAnalysis({Key? key}) : super(key: key);

  @override
  _WheelAnalysis createState() => _WheelAnalysis();
}

class _WheelAnalysis extends State<WheelAnalysis> {
  String selected_train_no = 'OL001';
  List<String> trainNumbers = List.generate(27, (index) {
    int number = index + 1;
    String formattedNumber = 'OL${number.toString().padLeft(3, '0')}';
    return formattedNumber;
  });

  bool isTrainNumberSelected = false;
  String apiResponse = '';

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
                      margin: EdgeInsets.fromLTRB(50, 15, 0, 25),
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
                              text: 'Wheel Analysis',
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
                    Padding(
                      padding: EdgeInsets.only(left: 35, top: 42),
                      child: Row(
                        children: [
                          Text(
                            'Train Number',
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFFF5F5F5),
                              // Add other styling properties as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, top: 6, bottom: 30),
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF313134),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: DropdownButtonFormField<String>(
                            value: selected_train_no,
                            items: trainNumbers.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Color(0xFFF5F5F5),
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selected_train_no =
                                    newValue ?? selected_train_no;
                                print("Selected option: $selected_train_no");
                                isTrainNumberSelected = true;
                                TrainToFlask(selected_train_no);
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF313134),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFF8518),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            elevation: 1,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFF5F5F5),
                            ),
                            dropdownColor: const Color(0xFF313134),
                          ),
                        ),
                      ),
                    ),
                    if (apiResponse.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(left: 35),
                        child: Column(
                          children: (jsonDecode(apiResponse) as List<dynamic>)
                              .map((item) {
                            int wheelSetNumber = item['WheelSetNumber'];
                            bool isFit = item['Fit'];

                            return ListTile(
                              title: Text('Wheel Set Number: $wheelSetNumber',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              subtitle: Text(
                                  'Result: ${isFit ? 'Fit' : 'Unfit'}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ),
                    // Stack(
                    //   children: [
                    //     Positioned(
                    //       left: 50, // Adjust left position as needed
                    //       top: 50, // Adjust top position as needed
                    //       child: Container(
                    //         height: 50,
                    //         width: 200,
                    //         child: ElevatedButton(
                    //           onPressed: () async {
                    //             await MyDashboard();
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(30.0),
                    //             ),
                    //           ),
                    //           child: Text(
                    //             'Submit',
                    //             style: TextStyle(fontSize: 18),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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

  Future<void> TrainToFlask(String selectedTrainNo) async {
    try {
      //const String apiUrl = 'http://192.168.0.115:8000/wheel_analysis';
      const String apiUrl = 'http://192.168.100.94:8000/wheel_analysis';
      final Map<String, String> jsonData = {
        'selected_train_no': selectedTrainNo,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData), // Convert jsonData to JSON
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
        print('Response: ${response.body}');
        // Handle the response from the server
        setState(() {
          apiResponse = response.body; // Update the response state
        });
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
        // Handle the error
      }
    } catch (e) {
      print('Error: $e');
      // Handle any exceptions
    }
  }

// List<Widget> _buildWheelSetInfo() {
//   // Parse the API response as a list of maps
//   List<Map<String, dynamic>> wheelSetInfoList = jsonDecode(apiResponse);

//   // Create a list of Widgets to display the information
//   List<Widget> wheelSetInfoWidgets = [];

//   for (var wheelSetInfo in wheelSetInfoList) {
//     // Extract the 'WheelSetNumber' and 'Fit' values
//     int wheelSetNumber = wheelSetInfo['WheelSetNumber'];
//     bool isFit = wheelSetInfo['Fit'];

//     // Create a Widget to display the information
//     Widget infoWidget = ListTile(
//       title: Text('Wheel Set Number: $wheelSetNumber'),
//       subtitle: Text('Fit: ${isFit ? 'Yes' : 'No'}'),
//     );

//     // Add the infoWidget to the list
//     wheelSetInfoWidgets.add(infoWidget);
//   }

//   return wheelSetInfoWidgets;
// }
}
