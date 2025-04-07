import 'package:flutter/material.dart';

class WaterGlass extends StatelessWidget {
  final double fillPercentage;

  const WaterGlass({
    super.key,
    required this.fillPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Water fill animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 300 * fillPercentage.clamp(0.0, 1.0),
            width: double.infinity,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          // Percentage text
          Center(
            child: Text(
              '${(fillPercentage * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
