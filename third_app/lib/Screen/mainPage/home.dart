import 'package:flutter/material.dart';
import 'dart:convert';
// Import the Uint8List type.
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:third_app/Screen/mainPage/EngineerDashboard.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  final String? path;

  Home({Key? key, this.path}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String graphUrl = 'http://127.0.0.1:8000/trending_graph';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                margin: EdgeInsets.only(top: 0, bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xddff8518),
                  borderRadius:
                      BorderRadius.circular(12), // Adjust the radius as needed
                ),
                height: 210,
                width: 1250,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 0), // Adjust left padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 20), // Adjust top padding here
                                child: Text(
                                  'Orange Line Metro Train',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Passenger Capacity',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '300 Person',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Total Staff',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '345',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 60),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Engine Fitness',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '100%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Maintenance and Repair',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'On Schedule',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/pic.png',
                        width: 500,
                        height: 400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align to the start (left)
                children: [
                  SizedBox(width: 60),
                  Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     SizedBox(width: 80), // Adjust as needed
              //     // Container(
              //     //   width: 600, // Adjust width as needed
              //     //   height: 500, // Adjust height as needed
              //     //   child: FutureBuilder<String>(
              //     //     future: fetchHtmlContent(),
              //     //     builder: (context, snapshot) {
              //     //       if (snapshot.connectionState ==
              //     //           ConnectionState.waiting) {
              //     //         return Center(
              //     //           child: CircularProgressIndicator(),
              //     //         );
              //     //       } else if (snapshot.hasError) {
              //     //         return Center(
              //     //           child: Text('Error: ${snapshot.error}'),
              //     //         );
              //     //       } else {
              //     //         return Html(data: snapshot.data);
              //     //       }
              //     //     },
              //     //   ),
              //     //   // FutureBuilder(
              //     //   //   future: http.get(Uri.parse(graphUrl)),
              //     //   //   builder: (context, snapshot) {
              //     //   //     if (snapshot.connectionState ==
              //     //   //         ConnectionState.waiting) {
              //     //   //       return CircularProgressIndicator();
              //     //   //     } else if (snapshot.hasError) {
              //     //   //       return Text('Error: ${snapshot.error}');
              //     //   //     } else if (snapshot.data != null &&
              //     //   //         snapshot.data!.bodyBytes != null) {
              //     //   //       // If the response data and body bytes are not null, display the image
              //     //   //       return Image.memory(
              //     //   //         snapshot.data!.bodyBytes!,
              //     //   //         fit: BoxFit.contain,
              //     //   //       );
              //     //   //     } else {
              //     //   //       return Text('Failed to load image');
              //     //   //     }
              //     //   //   },
              //     //   // ),
              //     // ),
              //     Container(
              //       child: SingleChildScrollView(
              //         child: FutureBuilder<String>(
              //           future: fetchHtmlContent(),
              //           builder: (context, snapshot) {
              //             if (snapshot.connectionState ==
              //                 ConnectionState.waiting) {
              //               return Center(
              //                 child: CircularProgressIndicator(),
              //               );
              //             } else if (snapshot.hasError) {
              //               return Center(
              //                 child: Text('Error: ${snapshot.error}'),
              //               );
              //             } else {
              //               return Html(data: snapshot.data);
              //             }
              //           },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     SizedBox(width: 80), // Adjust as needed
              //     Expanded(
              //       // Ensures the Container takes up all available horizontal space
              //       child: Container(
              //         width:
              //             double.infinity, // Set width to fill available space
              //         child: SingleChildScrollView(
              //           child: FutureBuilder<String>(
              //             future: fetchHtmlContent(),
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.waiting) {
              //                 return Center(
              //                   child: CircularProgressIndicator(),
              //                 );
              //               } else if (snapshot.hasError) {
              //                 return Center(
              //                   child: Text('Error: ${snapshot.error}'),
              //                 );
              //               } else {
              //                 return Html(data: snapshot.data);
              //               }
              //             },
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
    );
  }

  Future<String> fetchHtmlContent() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:5000')); // Replace with your Flask server URL
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load HTML content');
    }
  }
}

Widget _buildCard(String title, IconData icon) {
  return Card(
    color: Colors.grey[900],
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.orange,
            size: 100,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTimeContainer() {
  DateTime now = DateTime.now();
  String formattedTime =
      "${now.hour}:${now.minute} ${now.hour >= 12 ? 'PM' : 'AM'}";

  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(10),
    ),
    constraints: BoxConstraints(
      minHeight: 100,
      minWidth: 200,
    ),
    child: Column(
      children: [
        Text(
          'Current Time:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          formattedTime,
          style: TextStyle(color: Colors.orange, fontSize: 24),
        ),
      ],
    ),
  );
}
