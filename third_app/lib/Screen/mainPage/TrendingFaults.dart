// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// Future<List<dynamic>> fetchAllRows(String tableName) async {
//   var url = Uri.parse('https://typmqqidaijuobjosrpi.supabase.co/rest/v1/$tableName');
//   var response = await http.get(url, headers: {
//     "apikey": "Your-Supabase-Key",
//     "Authorization": "Bearer Your-Supabase-Key"
//   });

//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

// List<dynamic> filterFaultsByDate(List<dynamic> rows, DateTime startDate, DateTime endDate) {
//   return rows.where((row) {
//     var faultDate = DateFormat('yyyy-MM-dd').parse(row["OccurrenceDate"]);
//     return faultDate.isAfter(startDate) && faultDate.isBefore(endDate);
//   }).toList();
// }

// Map<String, int> aggregateFaults(List<dynamic> filteredFaults) {
//   Map<String, int> equipmentFaults = {};
//   for (var row in filteredFaults) {
//     var equipment = row["Equipment"];
//     if (equipment == "Others" || equipment == null) continue;
//     equipmentFaults[equipment] = (equipmentFaults[equipment] ?? 0) + 1;
//   }
//   return equipmentFaults;
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Trending Faults'),
        ),
        body: FaultsChart(),
      ),
    );
  }
}

class FaultData {
  final String equipment;
  final int faultsCount;

  FaultData(this.equipment, this.faultsCount);
}

class FaultsChart extends StatefulWidget {
  @override
  _FaultsChartState createState() => _FaultsChartState();
}

class _FaultsChartState extends State<FaultsChart> {
  late Future<List<FaultData>> _faultsData;

  @override
  void initState() {
    super.initState();
    _faultsData = fetchAndProcessData();
  }

  Future<List<FaultData>> fetchAndProcessData() async {
    // Replace these with your actual Supabase URL and Key
    const url = 'https://typmqqidaijuobjosrpi.supabase.co/rest/v1/FaultData';
    const headers = {
      'apikey':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c'
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> rawData = json.decode(response.body);
      final processedData = _processData(rawData);
      return processedData;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<FaultData> _processData(List<dynamic> rawData) {
    Map<String, int> equipmentFaults = {};

    for (var row in rawData) {
      final DateTime occurrenceDate =
          DateFormat('yyyy-MM-dd').parse(row['OccurrenceDate']);
      final DateTime startDate = DateTime(2020, 3, 1);
      final DateTime endDate = DateTime(2024, 3, 15);

      if (occurrenceDate.isAfter(startDate) &&
          occurrenceDate.isBefore(endDate)) {
        final String equipment = row['Equipment'] ?? 'Unknown';
        if (equipment != 'Others') {
          equipmentFaults[equipment] = (equipmentFaults[equipment] ?? 0) + 1;
        }
      }
    }

    final sortedEquipmentFaults = equipmentFaults.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEquipmentFaults
        .take(10)
        .map((e) => FaultData(e.key, e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FaultData>>(
      future: _faultsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Trending Faults'),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <BarSeries<FaultData, String>>[
              BarSeries<FaultData, String>(
                dataSource: snapshot.data!,
                xValueMapper: (FaultData faults, _) => faults.equipment,
                yValueMapper: (FaultData faults, _) => faults.faultsCount,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
