import 'package:weather/models/condition.dart';

class Current {
  final String tempF;
  final String tempC;
  final bool isDay;
  final String windKph;
  final String windmPh;
  final String humidity;
  final String feelsLikeC;
  final String feelsLikeF;
  final Condition condition;
  final String date;

  const Current({
    required this.tempF,
    required this.tempC,
    required this.isDay,
    required this.windKph,
    required this.windmPh,
    required this.humidity,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.condition,
    required this.date,
  });
}
