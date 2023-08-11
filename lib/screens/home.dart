import 'package:flutter/material.dart';
import 'package:weather/screens/weather_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFF1A1C1E),
      body: SafeArea(
        child: WeatherScreen(),
      ),
    );
  }
}
