import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo',
    home: ReportScreen(),
  ));
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Uint8List? _pdfData;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final ByteData data = await rootBundle.load('assets/sample.pdf');
    setState(() {
      _pdfData = data.buffer.asUint8List();
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
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF313134),
                  borderRadius: BorderRadius.circular(8.2151851654),
                ),
                constraints: BoxConstraints(
                  maxWidth: 700,
                  maxHeight: 1000,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_pdfData != null)
                      Container(
                        height: 800,
                        child: SfPdfViewer.memory(
                          _pdfData!,
                        ),
                      )
                    else
                      CircularProgressIndicator(),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => _printPdf(),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(200, 50), // Set the minimum size of the button
                        ),
                      ),
                      child: Text(
                        'Print Report',
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontSize: 18, // Adjust font size as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printPdf() async {
    if (_pdfData != null) {
      await Printing.layoutPdf(
        onLayout: (_) async => _pdfData!,
      );
    } else {
      // Handle case where PDF data is not available
    }
  }
}
