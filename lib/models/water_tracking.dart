import 'package:shared_preferences/shared_preferences.dart';

class WaterTracking {
  final double goal;
  double _currentAmount = 0;

  WaterTracking({required this.goal});

  double get currentAmount => _currentAmount;
  double get percentage => _currentAmount / goal;

  void addWater(double amount) {
    _currentAmount = (_currentAmount + amount).clamp(0, goal);
  }

  void reset() {
    _currentAmount = 0;
  }

  static Future<void> saveGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('water_goal', goal);
  }

  static Future<double?> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('water_goal');
  }
}
