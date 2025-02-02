import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  String apiKey = dotenv.env['API_KEY'] ?? '';
  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data!");
    }
  }

  Future<String> getUserCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the cityName
    String? cityname = placeMarks[0].locality;

    return cityname ?? "";
  }
}
