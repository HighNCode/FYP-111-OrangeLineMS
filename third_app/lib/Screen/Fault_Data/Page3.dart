import 'package:flutter/material.dart';
// Import the Uint8List type.
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:third_app/Screen/mainPage/MyDashboard.dart';

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
  String selectedValue5 = 'Open'; // Default selected value
  bool? isChecked = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  // bool selectedValue = false;
// ...
  bool getSelectedValue() {
    if (isChecked == true) {
      return true; // 'Yes' is selected
    } else if (isChecked2 == true) {
      return false; // 'No' is selected
    }
    return false;
  }

  TextEditingController _resdateController = TextEditingController();
  DateTime selectedResDate = DateTime.now();
  String dateErrorRes = ' ';

  void _validateResDate(String input) {
    if (input.isNotEmpty) {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      try {
        dateFormat.parseStrict(input);
        setState(() {
          dateErrorRes = ' ';
        });
      } catch (e) {
        setState(() {
          dateErrorRes = 'Invalid date format. Please use dd-mm-yyyy.';
        });
      }
    }
  }

  void validateFields() {
    _validateResDate(_resdateController.text);
  }

  Future<void> selectResDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedResDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedResDate) {
      setState(() {
        selectedResDate = picked;
        _resdateController.text = "${picked.toLocal()}".split(' ')[0];
      });
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
                              text: 'Fault Data Entry',
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
                    Container(
                      margin: EdgeInsets.fromLTRB(55, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(41, 20, 12, 20),
                      height: 80,
                      width: 750,
                      decoration: BoxDecoration(
                        color: Color(0xFF222229),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 43, 0.18),
                            child: Center(
                              child: Text(
                                'General Information',
                                style: TextStyle(
                                  fontSize: 20.2151851654,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 0.18),
                            // child: Text(
                            //   'Fault Description',
                            //   style: TextStyle(
                            //     fontSize: 20.2151851654,
                            //     fontWeight: FontWeight.w400,
                            //     color: Color(0xFFFFFFFF),
                            //   ),
                            // ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 0, 0, 0.18),
                            child: Text(
                              'Fault Status',
                              style: TextStyle(
                                fontSize: 20.2151851654,
                                fontWeight: FontWeight.w400,
                                color: Color(0xddff8518),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        //   Container(
                        //     margin: EdgeInsets.fromLTRB(55, 0, 0, 0.10),
                        //     width: 510,
                        //     height: 8,
                        //     decoration: BoxDecoration(
                        //       color: Color(0xFF222229),
                        //     ),
                        //   ),
                        Container(
                          // No margin for the second Container
                          margin: EdgeInsets.fromLTRB(55, 0, 0, 0.10),
                          width: 750,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xddff8518),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Row(
                        children: [
                          Text(
                            'Fault Status',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 168,
                            height: 40,
                            child: DropdownButton<String>(
                              value: selectedValue5,
                              items: [
                                'Open',
                                'Closed',
                                'Pending',
                                'Under Observation',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue5 = newValue!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Color(0xddff8518)),
                              iconSize: 24,
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            'Resolution Date',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 180,
                            height: 50,
                            child: TextFormField(
                              controller: _resdateController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'dd-mm-yyyy',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () => selectResDate(context),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xddff8518),
                                    width: 2,
                                  ),
                                ),
                                errorText: dateErrorRes,
                              ),
                              onTap: () => selectResDate(context),
                              onChanged: _validateResDate,
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
              left: 220,
              top: 600,
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 710),
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // sendData(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyDashboard(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 20,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xddff8518),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
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
              left: 710,
              top: 280,
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            'Spare Parts Consumed',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 60), // Use EdgeInsets.only for left padding
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                activeColor: Color(0xddff8518),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked = newBool;
                                  });
                                },
                              ),
                              Text('Yes'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 60), // Use EdgeInsets.only for left padding
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked2,
                                activeColor: Color(0xddff8518),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked2 = newBool;
                                  });
                                },
                              ),
                              Text('No'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Add spacing between the sections
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5, // Add spacing between the text and "*"
                          ),
                          Text(
                            'Parts Swapped',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Color(0xffffffff),
                            ),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 60), // Use EdgeInsets.only for left padding
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked3,
                                activeColor: Color(0xddff8518),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked3 = newBool;
                                  });
                                },
                              ),
                              Text('Yes'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 60), // Use EdgeInsets.only for left padding
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked4,
                                activeColor: Color(0xddff8518),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked4 = newBool;
                                  });
                                },
                              ),
                              Text('No'),
                            ],
                          ),
                        ),
                      ],
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
