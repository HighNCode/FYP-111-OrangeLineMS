import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Repetitive Faults Chart'),
        ),
        body: RepetitiveFaultsChart(),
      ),
    );
  }
}

class EquipmentFault {
  final String equipmentKey;
  final int count;
  final DateTime date;

  EquipmentFault(this.equipmentKey, this.count, this.date);
}

class RepetitiveFaultsChart extends StatefulWidget {
  @override
  _RepetitiveFaultsChartState createState() => _RepetitiveFaultsChartState();
}

class _RepetitiveFaultsChartState extends State<RepetitiveFaultsChart> {
  late Future<List<EquipmentFault>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchEquipmentFaults();
  }

  Future<List<EquipmentFault>> fetchEquipmentFaults() async {
    const String url = 'https://typmqqidaijuobjosrpi.supabase.co/rest/v1/FaultData';
    final response = await http.get(Uri.parse(url), headers: {
      'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c',
    });

    if (response.statusCode == 200) {
      final List rawData = json.decode(response.body);
      return processData(rawData);
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<EquipmentFault> processData(List<dynamic> rawData) {
    Map<String, Map<String, dynamic>> equipmentFaults = {};
    DateTime currentDateTime = DateTime.now();
    DateTime lastWeekDateTime = currentDateTime.subtract(Duration(days: 220));

    for (var row in rawData) {
      String equipment = row["Equipment"] ?? "Unknown";
      String trainNumber = row["TrainNumber"].toString();
      String carNumber = row["CarNumber"].toString();
      DateTime faultDate = DateTime.parse(row["OccurrenceDate"]);

      if (equipment == "Others" || equipment.isEmpty) continue;

      String equipmentKey = "$equipment\_$trainNumber\_$carNumber";

      if (!equipmentFaults.containsKey(equipmentKey)) {
        equipmentFaults[equipmentKey] = {
          "count": 0,
          "date": faultDate,
        };
      }
      else{
        equipmentFaults[equipmentKey]?["count"] += 1;
        equipmentFaults[equipmentKey]?["date"] = faultDate;
      }
      
    }

    List<EquipmentFault> filteredFaults = [];

    equipmentFaults.forEach((key, value) {
      DateTime date = value["date"];
      int count = value["count"];

      if (date.isAfter(lastWeekDateTime) && count > 1) {
        filteredFaults.add(EquipmentFault(key, count, date));
      }
    });

    filteredFaults.sort((a, b) => b.date.compareTo(a.date));

    return filteredFaults;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EquipmentFault>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: snapshot.data!.length * 100.0,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<EquipmentFault, String>>[
                  BarSeries<EquipmentFault, String>(
                    dataSource: snapshot.data!,
                    xValueMapper: (EquipmentFault fault, _) =>
                        fault.equipmentKey,
                    yValueMapper: (EquipmentFault fault, _) => fault.count,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    pointColorMapper: (EquipmentFault fault, _) =>
                        fault.date.isAtSameMomentAs(DateTime.now())
                            ? Colors.red
                            : Colors.blue,
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
