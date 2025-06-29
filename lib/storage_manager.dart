import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'battery_snapshot.dart';

class StorageManager {
  // Cosntants
  static const _storageKey = 'battery_snapshots';
  static const _snapshots = 48;

  // Singleton
  static final StorageManager _instance = StorageManager._();

  static StorageManager get instance => _instance;

  StorageManager._();

  // Internal parameters
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> recordBatterySnapshot(BatterySnapshot snapshot) async {
    if (_prefs == null) return;

    final List<String> snapshotList = _prefs!.getStringList(_storageKey) ?? [];

    if (snapshotList.length > _snapshots) {
      snapshotList.removeRange(0, snapshotList.length - _snapshots);
    }

    snapshotList.add(jsonEncode(snapshot.toJson()));

    await _prefs?.setStringList(_storageKey, snapshotList);
  }

  List<BatterySnapshot> readBatterySnapshots() {
    if (_prefs == null) return [];

    final List<String> snapshotList = _prefs?.getStringList(_storageKey) ?? [];

    return snapshotList
        .map((jsonStr) => BatterySnapshot.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
