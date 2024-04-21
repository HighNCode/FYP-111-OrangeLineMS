import 'dart:io';
import 'package:flutter/material.dart';

class FaultsEditor extends StatefulWidget {
  @override
  _FaultsEditorState createState() => _FaultsEditorState();
}

class _FaultsEditorState extends State<FaultsEditor> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Faults'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Fault',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editFaults('faults.txt', _controller.text);
              },
              child: Text('Save Fault'),
            ),
          ],
        ),
      ),
    );
  }

  void _editFaults(String fileName, String fault) {
    File file = File(fileName);

    try {
      // Open the file for appending
      IOSink sink = file.openWrite(mode: FileMode.append);

      // Write the fault to the file
      sink.writeln(fault);

      // Close the sink
      sink.close();

      // Clear the text field after saving
      _controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fault saved successfully.'),
        ),
      );
    } catch (e) {
      print('Error editing faults: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}
