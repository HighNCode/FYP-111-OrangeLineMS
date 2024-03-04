import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlotScreen extends StatefulWidget {
  @override
  _PlotScreenState createState() => _PlotScreenState();
}

class _PlotScreenState extends State<PlotScreen> {
  String plotData = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/get_plot'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        plotData = data['plot_data'];
      });
    } else {
      throw Exception('Failed to load plot data');
    }
  }

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
                            text: 'Prediction Preview',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 32,
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
                  SizedBox(height: 20),
                  Center(
                    child: plotData.isNotEmpty
                        ? Image.memory(
                            base64.decode(plotData),
                            width: 800,
                            height: 400,
                            fit: BoxFit.cover,
                          )
                        : CircularProgressIndicator(),
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
    );
  }
}
