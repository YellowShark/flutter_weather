import 'package:flutter_weather/data/fetch_hepler.dart';

class WeatherService {
  Future<dynamic> getWeatherByCoord(double lat, double lon) async {
    FetchHelper fetchData = FetchHelper(parameters: 'lat=$lat&lon=$lon');
    var decodedData = await fetchData.getData();
    return decodedData;
  }

  Future<dynamic> getWeatherByName(String cityName) async {
    FetchHelper fetchData = FetchHelper(parameters: 'q=$cityName');
    var decodedData = await fetchData.getData();
    return decodedData;
  }
}
