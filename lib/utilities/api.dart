import 'package:dio/dio.dart';

class Api {
  final _baseUrl = 'http://api.weatherapi.com/v1';
  final _apiKey = '<your api key>';
  final _dio = Dio();

  getCurrentWeather(type, q) async {
    return await _dio.get("$_baseUrl/$type.json?key=$_apiKey&q=$q&aqi=no");
  }
}
