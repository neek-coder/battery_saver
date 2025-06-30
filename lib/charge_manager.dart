// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'dart:math' show min;

import 'package:battery_saver/storage_manager.dart';

class ChargeManager {
  static const fullBatteryLevel = 90;
  static const lowBatteryLevel = 20; // Lower bound

  static const k_charge = 1; // Estimate speed of charging

  static Future<Duration?> estimateTime(int minutesToChargeOnTime) async {
    final rawSnapshots = await StorageManager.readBatterySnapshots();
    final snapshots = rawSnapshots.getRange(
      rawSnapshots.length - 3,
      rawSnapshots.length,
    );

    final currentCharge = snapshots.first.batteryLevel;

    // Average rate oof discharge over the course of the last 45 minutes
    final k_discharge =
        (snapshots.last.batteryLevel - snapshots.first.batteryLevel) / 45;

    if (k_discharge >= 0) return null;

    // Time left before charge reaches the lower bound
    final dt_bound = -(currentCharge - lowBatteryLevel) / k_discharge;

    // Time left before the phone has to be put onn charge in order to charge on time
    final dt_charge =
        (currentCharge - fullBatteryLevel + k_charge * minutesToChargeOnTime) /
        (k_charge - k_discharge);

    // The phone should have been put on charge by now
    if (dt_bound <= 0 || dt_charge <= 0) {
      return Duration.zero;
    }

    final dt = min(dt_bound.round(), dt_charge.round());

    if (dt < 50) {
      return Duration(minutes: dt);
    }

    return null;
  }
}
