import 'package:flutter/material.dart';

class WaterTrackerScreen extends StatelessWidget {
  final double waterGoal;

  const WaterTrackerScreen({
    super.key,
    required this.waterGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DrinkBuddy'),
      ),
      body: Center(
        child: Text('Water Tracker Screen - Goal: $waterGoal L'),
      ),
    );
  }
}
