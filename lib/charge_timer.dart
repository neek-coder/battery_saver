import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChargeTimer extends StatelessWidget {
  const ChargeTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
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
                'Last 12 hours'.toUpperCase(),
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
