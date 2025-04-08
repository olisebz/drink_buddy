import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:drink_buddy/models/water_tracking.dart';
import 'package:drink_buddy/widgets/water_glass.dart';
import 'package:drink_buddy/screens/goal_input_screen.dart';

class WaterTrackerScreen extends StatefulWidget {
  final double waterGoal;

  const WaterTrackerScreen({
    super.key,
    required this.waterGoal,
  });

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late WaterTracking _waterTracking;
  bool _isShakeDetectionActive = true;
  DateTime? _lastShakeTime;

  static const double _shakeThreshold = 35;
  static const Duration _minTimeBetweenShakes = Duration(milliseconds: 500);
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  DateTime? _lastAccelUpdate;

  @override
  void initState() {
    super.initState();
    _waterTracking = WaterTracking(goal: widget.waterGoal);
    _setupShakeDetection();
  }

  void _setupShakeDetection() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_isShakeDetectionActive) return;

      final now = DateTime.now();

      //Minimum time between readings is ensured
      if (_lastAccelUpdate != null &&
          now.difference(_lastAccelUpdate!) <
              const Duration(milliseconds: 100)) {
        return;
      }
      _lastAccelUpdate = now;

      // Calculat change in acceleration
      final double deltaX = event.x - _lastX;
      final double deltaY = event.y - _lastY;
      final double deltaZ = event.z - _lastZ;

      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;

      // delta of acceleration
      final double deltaAccel = (deltaX.abs() + deltaY.abs() + deltaZ.abs());

      // Check shake and enough time passed since last shake
      if (deltaAccel > _shakeThreshold &&
          (_lastShakeTime == null ||
              now.difference(_lastShakeTime!) > _minTimeBetweenShakes)) {
        _lastShakeTime = now;
        _openEmailShare();
      }
    });
  }

  Future<void> _openEmailShare() async {
    const subject = 'Trink mit mir!';
    const body =
        'Hey Leute, begleitet mich beim Trinken, damit ich mein tägliches Ziel schaffe!';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      query: 'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );

    if (!await launchUrl(emailLaunchUri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konnte Mail-App nicht öffnen'),
        ),
      );
    }
  }

  void _addWater(double amount) {
    setState(() {
      _waterTracking.addWater(amount);
    });
  }

  void _resetProgress() {
    setState(() {
      _waterTracking.reset();
    });
  }

  void _setNewGoal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GoalInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasser Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wasser ist Leben! Bleib hydriert!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            WaterGlass(fillPercentage: _waterTracking.percentage),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WaterButton(
                  amount: 0.2,
                  onPressed: () => _addWater(0.2),
                ),
                _WaterButton(
                  amount: 0.5,
                  onPressed: () => _addWater(0.5),
                ),
                _WaterButton(
                  amount: 1.0,
                  onPressed: () => _addWater(1.0),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Zurück setzen'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _setNewGoal,
              child: const Text('Neues Trink Ziel'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final double amount;
  final VoidCallback onPressed;

  const _WaterButton({
    required this.amount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        '+${amount}L',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
