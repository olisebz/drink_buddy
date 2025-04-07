import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_buddy/screens/water_tracker_screen.dart';

class GoalInputScreen extends StatefulWidget {
  const GoalInputScreen({super.key});

  @override
  State<GoalInputScreen> createState() => _GoalInputScreenState();
}

class _GoalInputScreenState extends State<GoalInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveGoalAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      final double goal = double.parse(_controller.text);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('water_goal', goal);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WaterTrackerScreen(waterGoal: goal),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setze dein Trink Ziel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wie viel Wasser möchtest du Heute trinken?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Tägliches Ziel (in Liter)',
                  border: OutlineInputBorder(),
                  suffixText: 'L',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib ein Ziel ein';
                  }
                  final double? number = double.tryParse(value);
                  if (number == null) {
                    return 'Bitte gib eine gültige Zahl ein';
                  }
                  if (number <= 0) {
                    return 'Das Ziel muss grösser als 0 sein';
                  }
                  if (number > 10) {
                    return 'Das Ziel sollte nicht grösser als 10L sein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGoalAndNavigate,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  'Ziel speichern',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
