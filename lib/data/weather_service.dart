import 'package:flutter_weather/data/consts.dart';
import 'package:flutter_weather/data/fetch_hepler.dart';

class WeatherService {
  String get baseUrl => Consts.baseUrl;
  String get weatherMapKey => Consts.openWeatherMapKey;
  String get weather => 'weather';

  Future<dynamic> getWeatherByCoord(double lat, double lon) async {
    FetchHelper fetchData = FetchHelper(
        "$baseUrl$weather?lat=$lat&lon=$lon&appid=$weatherMapKey&units=metric");

    var decodedData = await fetchData.getData();
    return decodedData;
  }

  Future<dynamic> getWeatherByName(String cityName) async {
    FetchHelper fetchData = FetchHelper(
        "$baseUrl$weather?q=$cityName&appid=$weatherMapKey&units=metric");

    var decodedData = await fetchData.getData();
    return decodedData;
  }
}