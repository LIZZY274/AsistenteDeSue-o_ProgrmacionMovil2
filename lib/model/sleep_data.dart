class SleepData {
  final double sleepHours;
  final double sleepQuality;
  final int sleepScore;
  final DateTime date;
  final String sleepPhase;

  SleepData({
    required this.sleepHours,
    required this.sleepQuality,
    required this.sleepScore,
    required this.date,
    required this.sleepPhase,
  });
}

class SleepStats {
  final double averageSleep;
  final double deepSleepPercent;
  final double remSleepPercent;
  final int totalNaps;

  SleepStats({
    required this.averageSleep,
    required this.deepSleepPercent,
    required this.remSleepPercent,
    required this.totalNaps,
  });
}
