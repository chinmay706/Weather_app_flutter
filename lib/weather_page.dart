import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherServices = WeatherService('dcdea9e45c08d9b2a453b17812d5bf87');
  Weather? _weather;
  // fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherServices.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City
            Text(
              _weather?.cityName ?? "loading city..",
              textAlign: TextAlign.center, // Center the text horizontally
            ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // Temperature
            Text(
              '${_weather?.temperature.round() ?? "null temp"}°C',
              textAlign: TextAlign.center, // Center the text horizontally
            ),
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
