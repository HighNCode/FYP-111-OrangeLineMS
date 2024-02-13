import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:third_app/Screen/Wheel_Analysis/Page1.dart';
import 'package:third_app/Screen/fault_detection/Page3.dart';
import 'package:third_app/Screen/Fault_Data/first.dart';
import 'package:third_app/Screen/Wheel Data OCR/ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MyDashboard(),
    );
  }
}

class MyDashboard extends StatefulWidget {
  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  int _selectedMenuItem = 0; // Track the selected menu item
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            // Add an image here
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Image.asset(
                'assets/Logo.png', // Replace with your image asset
                width: 70, // Adjust the width as needed
                height: 50, // Adjust the height as needed
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
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  if (value.toLowerCase() == 'wheel analysis') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Page1()),
                    );
                  }
                },
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
      drawer: MyDrawer(
        selectedMenuItem: _selectedMenuItem,
        onMenuItemSelected: (int index) {
          setState(() {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyDashboard()));
            } else {
              _selectedMenuItem = index;
              print(_selectedMenuItem);
              if (index == 1) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Page1()));
              } else if (index == 2) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => first()));
              } else if (index == 3) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Page3()));
              } else if (index == 4) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ocr()));
              } else {
                // Handle other menu items or scenarios if needed
                print('fail');
              }
            }
          });
          // Navigator.pop(context);
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 20),
              color: Color(0xddff8518),
              height: 200,
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
                            Text(
                              'Lahore Metro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                SizedBox(width: 60),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 60),
                _buildCard('Statistics', Icons.show_chart),
                SizedBox(width: 180), // Add space between cards
                _buildCard('Tasks', Icons.assignment),
                SizedBox(width: 180),
                _buildTimeContainer(),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
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

class MyDrawer extends StatelessWidget {
  final int selectedMenuItem;
  final Function(int) onMenuItemSelected;

  const MyDrawer({
    Key? key,
    required this.selectedMenuItem,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF313134), // Set the background color for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: Color(0xFF313134),
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF313134),
                ),
              ),
            ),
            Container(
              height: 910,
              color: Color(0xFF313134),
              child: Column(
                children: <Widget>[
                  _buildMenuItem(0, 'Home', Icons.home),
                  _buildMenuItem(1, 'Wheel Data Form', Icons.data_usage),
                  _buildMenuItem(2, 'Fault Data Form', Icons.edit),
                  _buildMenuItem(3, 'Fault Detection', Icons.warning),
                  _buildMenuItem(4, 'Wheel Analysis', Icons.analytics),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: selectedMenuItem == index ? Color(0xddff8518) : Colors.white,
        ),
      ),
      onTap: () {
        onMenuItemSelected(index);
      },
      leading: Icon(
        icon,
        color: selectedMenuItem == index ? Color(0xddff8518) : Colors.white,
      ),
    );
  }
}
