import 'package:battery_plus/battery_plus.dart';

class BatterySnapshot {
  final int batteryLevel;
  final BatteryState state;
  final DateTime timestamp;

  BatterySnapshot({
    required this.batteryLevel,
    required this.state,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'batteryLevel': batteryLevel,
    'state': state.name,
    'timestamp': timestamp.toIso8601String(),
  };

  factory BatterySnapshot.fromJson(Map<String, dynamic> json) {
    return BatterySnapshot(
      batteryLevel: json['batteryLevel'],
      state: BatteryState.values.byName(json['state']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  static Future<BatterySnapshot> takeSnapshot() async {
    final battery = Battery();
    final level = await battery.batteryLevel;
    final state = await battery.batteryState;

    return BatterySnapshot(
      batteryLevel: level,
      state: state,
      timestamp: DateTime.now(),
    );
  }
}
