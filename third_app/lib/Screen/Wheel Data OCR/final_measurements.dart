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
      home: FinalMeasurements(),
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

class FinalMeasurements extends StatefulWidget {
  const FinalMeasurements({super.key});

  @override
  _FinalMeasurementsState createState() => _FinalMeasurementsState();
}

class _FinalMeasurementsState extends State<FinalMeasurements> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111112),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Add an image here
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Image.asset(
                'assets/Logo.png', // Replace with your image asset
                width: 70, // Adjust the width as needed
                height: 70, // Adjust the height as needed
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orange Line Maintenance System',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),

            SizedBox(width: 325), // Add space between title and search bar
            Container(
              constraints: BoxConstraints(maxWidth: 260),
              child: TextField(
                // controller: _searchController1,
                // style: TextStyle(color: Colors.white),
                // onSubmitted: (value) {
                //   if (value.toLowerCase() == 'wheel analysis') {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => Page1()),
                //     );
                //   }
                // },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.orange, // Set the icon (menu) color to orange
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                top: 30,
                child: Container(
                  width: 895,
                  height: 590,
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
                                  text: 'Final',
                                  letterSpacing: 2.0,
                                ),
                                SizedBox(height: 8),
                                CustomTextWidget(
                                  text: 'Measurements',
                                  letterSpacing: 2.0,
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 35, top: 42),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    text: 'Diameter',
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 6),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager()
                                                  .trainData['A-LHS-Diameter'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-LHS-Diameter'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Left',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add spacing between the two columns
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager()
                                                  .trainData['A-RHS-Diameter'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-RHS-Diameter'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Right',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 35, top: 42),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    text: 'Flange Thickness',
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 6),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                                  'A-LHS-FlangeThickness'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-LHS-FlangeThickness'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Left',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add spacing between the two columns
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                                  'A-RHS-FlangeThickness'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 236, 214, 214),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-RHS-FlangeThickness'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Right',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 35, top: 42),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    text: 'Flange Width',
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 6),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                              'A-LHS-FlangeWidth'] = newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-LHS-FlangeWidth'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Left',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add spacing between the two columns
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                              'A-RHS-FlangeWidth'] = newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-RHS-FlangeWidth'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Right',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 35, top: 42),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    text: 'Flange Gradient',
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 6),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData['A-LHS-Qr'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager()
                                                    .trainData['A-LHS-Qr'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Left',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add spacing between the two columns
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData['A-RHS-Qr'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager()
                                                    .trainData['A-RHS-Qr'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Right',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 35, top: 42),
                              child: Row(
                                children: [
                                  CustomTextWidget(
                                    text: 'Radial Deviation',
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 35, top: 6, bottom: 30),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                                  'A-LHS-RadialDeviation'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-LHS-RadialDeviation'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Left',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        16), // Add spacing between the two columns
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ), // Adjust the width as needed
                                      child: TextField(
                                        onChanged: (newValue) {
                                          DataManager().trainData[
                                                  'A-RHS-RadialDeviation'] =
                                              newValue;
                                        },
                                        style: const TextStyle(
                                          color: Color(0xFFF5F5F5),
                                        ),
                                        controller: TextEditingController(
                                            text: DataManager().trainData[
                                                    'A-RHS-RadialDeviation'] ??
                                                ''),
                                        decoration: InputDecoration(
                                          hintText: 'Right',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: const Color(0xFF313134),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFFF8518),
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
