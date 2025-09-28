import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../model/sleep_data.dart';

class SleepViewModel extends ChangeNotifier {

  bool _isNightMode = false;
  bool _isNapping = false;
  bool _isTracking = false;
  
  
  Timer? _napTimer;
  int _napDuration = 20 * 60;
  int _currentNapTime = 0;
  
  SleepData _currentSleepData = SleepData(
    sleepHours: 7.5,
    sleepQuality: 0.85,
    sleepScore: 92,
    date: DateTime.now(),
    sleepPhase: 'Despierto',
  );
  
  SleepStats _sleepStats = SleepStats(
    averageSleep: 7.2,
    deepSleepPercent: 0.68,
    remSleepPercent: 0.42,
    totalNaps: 15,
  );
  
  
  late AnimationController _progressController;
  double _sleepProgress = 0.0;
  List<Offset> _stars = [];
  Timer? _animationTimer;
  
  
  bool get isNightMode => _isNightMode;
  bool get isNapping => _isNapping;
  bool get isTracking => _isTracking;
  int get napDuration => _napDuration;
  int get currentNapTime => _currentNapTime;
  SleepData get currentSleepData => _currentSleepData;
  SleepStats get sleepStats => _sleepStats;
  double get sleepProgress => _sleepProgress;
  List<Offset> get stars => _stars;
  
  
  Color get primaryColor => _isNightMode ? Color(0xFF1A1A2E) : Color(0xFF87CEEB);
  Color get secondaryColor => _isNightMode ? Color(0xFF16213E) : Color(0xFFB0E0E6);
  Color get accentColor => _isNightMode ? Color(0xFF0F3460) : Color(0xFF4682B4);
  
  SleepViewModel() {
    _generateStars();
    _startAnimations();
  }
  
  void _generateStars() {
    _stars = List.generate(50, (index) {
      return Offset(
        Random().nextDouble(),
        Random().nextDouble(),
      );
    });
  }
  
  void _startAnimations() {
    _animationTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _sleepProgress = (sin(timer.tick * 0.1) + 1) / 2;
      notifyListeners();
    });
  }
  
  void toggleNightMode() {
    _isNightMode = !_isNightMode;
    notifyListeners();
  }
  
  void startNap() {
    if (_isNapping) return;
    
    _isNapping = true;
    _currentNapTime = _napDuration;
    
    _napTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentNapTime > 0) {
        _currentNapTime--;
        notifyListeners();
      } else {
        stopNap();
      }
    });
    notifyListeners();
  }
  
  void stopNap() {
    _isNapping = false;
    _napTimer?.cancel();
    _currentNapTime = 0;
    _sleepStats = SleepStats(
      averageSleep: _sleepStats.averageSleep,
      deepSleepPercent: _sleepStats.deepSleepPercent,
      remSleepPercent: _sleepStats.remSleepPercent,
      totalNaps: _sleepStats.totalNaps + 1,
    );
    notifyListeners();
  }
  
  void toggleTracking() {
    _isTracking = !_isTracking;
    if (_isTracking) {
      _currentSleepData = SleepData(
        sleepHours: _currentSleepData.sleepHours,
        sleepQuality: _currentSleepData.sleepQuality,
        sleepScore: _currentSleepData.sleepScore,
        date: DateTime.now(),
        sleepPhase: 'Durmiendo',
      );
    } else {
      _currentSleepData = SleepData(
        sleepHours: _currentSleepData.sleepHours + 0.1,
        sleepQuality: min(1.0, _currentSleepData.sleepQuality + 0.01),
        sleepScore: min(100, _currentSleepData.sleepScore + 1),
        date: DateTime.now(),
        sleepPhase: 'Despierto',
      );
    }
    notifyListeners();
  }
  
  String get formattedNapTime {
    int minutes = _currentNapTime ~/ 60;
    int seconds = _currentNapTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _napTimer?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }
}
