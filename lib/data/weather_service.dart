import 'package:flutter_weather/data/fetch_hepler.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  Future<dynamic> getWeatherByCoord(Position position) async {
    final lat = position.latitude;
    final lon = position.longitude;
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
