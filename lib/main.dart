import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:battery_saver/battery_snapshot.dart';
import 'package:battery_saver/charge_timer.dart';
import 'package:battery_saver/storage_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'battery_chart.dart';

const batteryTaskName = "logBatteryLevel";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final snapshot = await BatterySnapshot.takeSnapshot();

    await StorageManager.recordBatterySnapshot(snapshot);

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );

  // final p = await SharedPreferences.getInstance();
  // await p.clear();
  // await Workmanager().cancelAll();

  bool isRegistered = await Workmanager().isScheduledByUniqueName(
    "batteryLogger",
  );

  if (!isRegistered) {
    await Workmanager().registerPeriodicTask(
      "batteryLogger", // Unique ID
      batteryTaskName,
      frequency: Duration(minutes: 15), // Minimum allowed
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BatterySnapshot>? _list;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loadedList = await StorageManager.readBatterySnapshots();

      setState(() {
        _list = loadedList;
        print(_list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_list != null) {
      if (_list!.length < 48) {
        _list = [
          ...List.generate(
            48 - _list!.length,
            (_) => BatterySnapshot(
              batteryLevel: 0,
              state: BatteryState.charging,
              timestamp: DateTime.now(),
            ),
          ),
          ..._list!,
        ];
      }
    }

    return Scaffold(
      floatingActionButton: TextButton(
        onPressed: () {
          Workmanager().registerOneOffTask(
            "ses",
            "sus",
            initialDelay: Duration(seconds: 5),
          );
        },
        child: Text("aiaiai"),
      ),
      backgroundColor: CupertinoColors.systemGrey5,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Battery Saver',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600, // semibold
                      color: Color(0xFF000000), // solid black text
                      letterSpacing: -0.41, // iOS style letter spacing
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              BatteryChart(
                barsCount: 48,
                barGroups: (width) => List.generate(
                  48,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _list?.elementAt(i).batteryLevel.toDouble() ?? 0,
                        color:
                            (_list == null ||
                                _list?.elementAt(i).state ==
                                    BatteryState.discharging ||
                                _list?.elementAt(i).state ==
                                    BatteryState.unknown)
                            ? CupertinoColors.systemYellow
                            : CupertinoColors.activeGreen,
                        width: width,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              ChargeTimer(),
            ],
          ),
        ),
      ),
    );
  }
}
