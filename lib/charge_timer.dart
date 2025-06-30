import 'package:battery_saver/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChargeTimer extends StatefulWidget {
  const ChargeTimer({super.key});

  @override
  State<ChargeTimer> createState() => _ChargeTimerState();
}

class _ChargeTimerState extends State<ChargeTimer> {
  DateTime? _chargeTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loadedTime = await StorageManager.getChargeTime();
      setState(() {
        _chargeTime = loadedTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10), // very light shadow
            offset: Offset(0, 2), // slightly down
            blurRadius: 4, // soft blur
            spreadRadius: 0, // no spread
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Charge timer'.toUpperCase(),
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(_chargeTime?.hour ?? 20).toString().padLeft(2, '0')}:${(_chargeTime?.minute ?? 0).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 51),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque, // expands the tap area
                onTap: () async {
                  final time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (time == null) return;

                  setState(() {
                    _chargeTime = DateTime(2020, 1, 1, time.hour, time.minute);
                    StorageManager.setChargeTime(_chargeTime!);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Set time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
