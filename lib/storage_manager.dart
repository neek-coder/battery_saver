import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'battery_snapshot.dart';

class StorageManager {
  // Cosntants
  static const _chargeTimeStorageKey = 'charge_time';
  static const _batterySnapshotsStorageKey = 'battery_snapshots';
  static const _snapshots = 48;

  static Future<void> setChargeTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(_chargeTimeStorageKey, time.toIso8601String());
  }

  static Future<DateTime> getChargeTime() async {
    final prefs = await SharedPreferences.getInstance();

    final rawTime = prefs.getString(_chargeTimeStorageKey);

    return (rawTime == null)
        ? DateTime(2020, 1, 1, 20)
        : DateTime.parse(rawTime);
  }

  @pragma('vm:entry-point')
  static Future<void> recordBatterySnapshot(BatterySnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> snapshotList =
        prefs.getStringList(_batterySnapshotsStorageKey) ?? [];

    if (snapshotList.length > _snapshots) {
      snapshotList.removeRange(0, snapshotList.length - _snapshots);
    }

    snapshotList.add(jsonEncode(snapshot.toJson()));

    await prefs.setStringList(_batterySnapshotsStorageKey, snapshotList);
  }

  static Future<List<BatterySnapshot>> readBatterySnapshots() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> snapshotList =
        prefs.getStringList(_batterySnapshotsStorageKey) ?? [];

    return snapshotList
        .map((jsonStr) => BatterySnapshot.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
