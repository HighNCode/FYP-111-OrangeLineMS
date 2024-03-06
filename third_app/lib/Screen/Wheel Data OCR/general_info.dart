import 'package:flutter/material.dart';
import 'data_manager.dart';

//import 'app_data.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GeneralInfo(),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double letterSpacing;

  const CustomTextWidget({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(
      fontFamily: 'Open Sans',
      fontSize: 30,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFF8518),
    ),
    this.letterSpacing = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle.copyWith(letterSpacing: letterSpacing),
    );
  }
}

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({super.key});

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
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
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 35, top: 75),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: 'General',
                                letterSpacing: 2.0,
                              ),
                              SizedBox(height: 8),
                              CustomTextWidget(
                                text: 'Information',
                                letterSpacing: 2.0,
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35, top: 75), // Reduce padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextWidget(
                                text: 'Train Number',
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFFF5F5F5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (newValue) {
                                    DataManager().trainData['TrainNumber'] =
                                        newValue;
                                  },
                                  style: const TextStyle(
                                    color: Color(0xFFF5F5F5),
                                  ),
                                  controller: TextEditingController(
                                      text: DataManager()
                                              .trainData['TrainNumber'] ??
                                          ''),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Train Number',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: const Color(0xFF313134),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFFF8518), width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextWidget(
                                text: 'Wheel Set Number',
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFFF5F5F5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (newValue) {
                                    DataManager().trainData['WheelSetNumber'] =
                                        newValue;
                                  },
                                  style: const TextStyle(
                                    color: Color(0xFFF5F5F5),
                                  ),
                                  controller: TextEditingController(
                                      text: DataManager()
                                              .trainData['WheelSetNumber'] ??
                                          ''),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Wheel Set Number',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: const Color(0xFF313134),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFFF8518), width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35, top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextWidget(
                                text: 'Date',
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFFF5F5F5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (newValue) {
                                    DataManager().trainData['Date'] = newValue;
                                  },
                                  style: const TextStyle(
                                    color: Color(0xFFF5F5F5),
                                  ),
                                  controller: TextEditingController(
                                      text: DataManager().trainData['Date'] ??
                                          ''),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Date',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: const Color(0xFF313134),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFFF8518), width: 2.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35, top: 42, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextWidget(
                                text: 'Time',
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xFFF5F5F5),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (newValue) {
                                    DataManager().trainData['Time'] = newValue;
                                  },
                                  style: const TextStyle(
                                    color: Color(0xFFF5F5F5),
                                  ),
                                  controller: TextEditingController(
                                      text: DataManager().trainData['Time'] ??
                                          ''),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Time',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: const Color(0xFF313134),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFFF8518), width: 2.0),
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
