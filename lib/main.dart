import 'dart:math';

import 'package:battery_saver/battery_snapshot.dart';
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

    await StorageManager.instance.recordBatterySnapshot(snapshot);

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageManager.instance.init();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );

  bool isRegistered = await Workmanager().isScheduledByUniqueName(
    "batteryLogger",
  );

  if (!isRegistered) {
    await Workmanager().registerPeriodicTask(
      "batteryLogger", // Unique ID
      batteryTaskName,
      frequency: Duration(minutes: 15), // Minimum allowed
      initialDelay: Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresCharging: false,
      ),
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: Random().nextInt(100).toDouble(),
                        color: Random().nextBool()
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.systemYellow,
                        width: width,
                      ),
                    ],
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
