import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;
  String? _errorMessage;

  // Fetch weather for default city
  _fetchWeatherDefault() async {
    String cityName = await _weatherService.getUserCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null; // Clear error if successful
      });
    } catch (e) {
      setState(() {
        _errorMessage = "City not found. Please try again.";
        _weather = null; // Clear weather data on error
      });
    }
  }

  // Fetch weather based on city name
  _searchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null; // Clear error if successful
      });
    } catch (e) {
      setState(() {
        _errorMessage = "City not found. Please check the spelling.";
        _weather = null; // Clear weather data on error
      });
    }
  }

  // Choose animation based on weather condition
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    print(dotenv.env['API_KEY']);
    super.initState();
    _fetchWeatherDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(214, 125, 126, 207),
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Enter city name...',
            icon: Icon(Icons.search),
          ),
          onSubmitted: (cityName) {
            if (cityName.isNotEmpty) {
              _searchWeather(cityName);
            }
          },
        ),
        actions: [
          Tooltip(
            message: "Revert back to your location",
            child: IconButton(
              icon: Icon(Icons.my_location_sharp),
              onPressed: _fetchWeatherDefault,
            ),
          ),
        ],
      ),
      body: Center(
        child: _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City name
                  Text(
                    _weather?.cityName ?? "Loading city..",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),

                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                  // Temperature
                  Text(
                    '${_weather?.temperature.round()} °C',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
