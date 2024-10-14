import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;

  Weather? weather;
// fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getUserCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
       _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

// animations


// init state

@override
  void initState() {
    super.initState();
  _fetchWeather();    
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //City name
            Text(_weather?.cityName ?? "Loading city.."),
        
            //temperature
            Text('${_weather?.temperature.round()} °C')
          ],
        ),
      ),
    );
  }
}
