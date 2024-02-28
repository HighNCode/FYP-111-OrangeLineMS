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
      appBar: AppBar(
        title: Text('Flask and Flutter Integration'),
      ),
      body: Center(
        child: plotData.isNotEmpty
            ? Image.memory(
                base64.decode(plotData),
                width: 800,
                height: 400,
                fit: BoxFit.cover,
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
