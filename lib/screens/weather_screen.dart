import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/condition.dart';
import 'package:weather/models/current.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/screens/city_management.dart';
import 'package:weather/utilities/api.dart';
import 'package:weather/utilities/database.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    super.key,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  var db = Database();
  late City currentCity;
  late Current current;
  late List<Forecast> forecast;
  bool isLoading = false;

  getCity() async {
    await db.getDefaultCity().then((value) {
      setState(() {
        currentCity = value;
        getWeather();
      });
    });
  }

  getWeather() async {
    setState(() {
      isLoading = true;
    });
    final api = Api();
    final res = await api.getCurrentWeather('forecast', currentCity.name);
    var body = res.data;
    var cur = body['current'];
    var cast = body['forecast']['forecastday'][0]['hour'];

    setState(() {
      current = Current(
          tempF: cur['temp_f'].toInt().toString(),
          tempC: cur['temp_c'].toInt().toString(),
          isDay: cur['is_day'] == 1 ? true : false,
          windKph: cur['wind_kph'].toInt().toString(),
          windmPh: cur['wind_mph'].toInt().toString(),
          humidity: cur['humidity'].toInt().toString(),
          feelsLikeC: cur['feelslike_c'].toInt().toString(),
          feelsLikeF: cur['feelslike_f'].toInt().toString(),
          condition: Condition(
            text: cur['condition']['text'],
            icon: cur['condition']['icon'],
            code: cur['condition']['code'].toString(),
          ),
          date: body['forecast']['forecastday'][0]['date']);

      forecast = List.generate(
        cast.length,
        (index) => Forecast(
          temperature: cast[index]['temp_c'].toInt().toString(),
          time: (cast[index]['time'].toString()).substring(10),
          icon: cast[index]['condition']['icon'],
        ),
      );
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0XFF1A1C1E),
        ),
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Text(
                      currentCity.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      current.date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CityManagement(),
                          ),
                        );
                        if (res != null) {
                          setState(() {
                            currentCity = res;
                            getWeather();
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${current.tempC}°C",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      current.condition.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Image.network(
                      "http:${current.condition.icon}",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0XFF202329),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text(
                                '💨',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "${current.windKph} k/h",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                'Wind',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text(
                                '💦',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                current.humidity,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                'Humidity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Text(
                                '👓',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "${current.feelsLikeC}°C",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              const Text(
                                'Feels Like',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Today',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: forecast.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            color: Color(0XFF202329),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                forecast[index].time,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Image.network("http:${forecast[index].icon}"),
                              Text(
                                "${forecast[index].temperature}°C",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
