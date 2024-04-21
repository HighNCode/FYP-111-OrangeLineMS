import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class Fault {
  final int id;
  final String description;

  Fault({required this.id, required this.description});
}

class FaultsEditor extends StatefulWidget {
  @override
  _FaultsEditorState createState() => _FaultsEditorState();
}

class _FaultsEditorState extends State<FaultsEditor> {
  late SupabaseClient _client;
  List<String> _faultDescriptions = [];
  List<String> _systems = [];
  List<String> _equipments = [];
  String? _selectedSystem;
  String? _selectedEquipment;
  @override
  void initState() {
    super.initState();
    _initializeSupabase();
    _fetchFaultDescriptions();
    _fetchSystemAndEquipment();
  }

  void _initializeSupabase() {
    String supabase_url = "https://typmqqidaijuobjosrpi.supabase.co";
    String supabase_key =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c";

    _client = SupabaseClient(supabase_url, supabase_key);
  }

  Future<void> _fetchFaultDescriptions() async {
    final response =
        await _client.from('FaultDetection').select('fault_desc').execute();

    if (response.data == null) {
      print('No fault descriptions found');
      return;
    }

    List<String> faultDescriptions = [];

// Extract distinct fault descriptions
    for (var row in response.data!) {
      String? faultDesc = row['fault_desc'] as String?;
      if (faultDesc != null && !faultDescriptions.contains(faultDesc)) {
        faultDescriptions.add(faultDesc);
      }
    }
    setState(() {
      _faultDescriptions = faultDescriptions;
    });
  }

  Future<void> _fetchSystemAndEquipment() async {
    final response =
        await _client.from('FaultData').select('System, Equipment').execute();

    if (response.data == null) {
      print('No system and equipment found');
      return;
    }

    List<Map<String, dynamic>> data = [];

    // Convert response data to a list of maps
    for (var item in response.data!) {
      data.add(Map<String, dynamic>.from(item));
    }

    Set<String> systems = {};
    Set<String> equipments = {};

    for (var item in data) {
      if (item['System'] != null) {
        systems.add(item['System'] as String);
      }
      // Check if 'Equipment' field is not null before adding to the set
      if (item['Equipment'] != null) {
        equipments.add(item['Equipment'] as String);
      }
    }

    setState(() {
      _systems = systems.toList();
      _equipments = equipments.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/background.png'),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Faults',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _faultDescriptions.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: double.infinity, // Adjust width of the card
                        child: Card(
                          elevation: 2,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Color(0xFF313134), // Set background color
                          child: ListTile(
                            title: TextFormField(
                              style: TextStyle(
                                  color:
                                      Colors.white), // Set text color to white
                              initialValue: _faultDescriptions[index],
                              maxLines:
                                  2, // Limit the number of lines displayed
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16), // Adjust padding
                              ),
                              onChanged: (value) {
                                _faultDescriptions[index] = value;
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                _showFilterDialog(context);
              },
              icon: Icon(Icons.filter_list),
              label: Text('Filter'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Set button background color to orange
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Filter Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('System: '),
              DropdownButton<String>(
                value: _selectedSystem,
                onChanged: (value) {
                  setState(() {
                    _selectedSystem = value;
                  });
                },
                items: _systems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text('Equipment: '),
              DropdownButton<String>(
                value: _selectedEquipment,
                onChanged: (value) {
                  setState(() {
                    _selectedEquipment = value;
                  });
                },
                items:
                    _equipments.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
