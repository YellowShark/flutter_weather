import 'package:flutter/material.dart';
import 'package:flutter_weather/data/consts.dart';
import 'package:flutter_weather/data/location_service.dart';
import 'package:flutter_weather/data/weather_service.dart';
import 'package:flutter_weather/screens/widgets/search_form.dart';
import 'package:flutter_weather/screens/widgets/weather_card.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  final _locationService = LocationService();
  String _city = '';
  String _icon = '';
  int _temp = 0;
  Color _color = Colors.white;
  String _desc = '';
  Position? _position;

  @override
  void initState() {
    super.initState();
    _getCurrentPositionAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 1.0],
            colors: [_color, Colors.white],
          ),
        ),
        child: Center(
          child: _content,
        ),
      ),
    );
  }

  Widget get _content => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchForm(onSearch: _changeCity),
            Text(
              _city,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            if (_city != "")
              WeatherCard(
                title: _desc,
                temperature: _temp,
                iconCode: _icon,
              )
          ],
        ),
      );

  void _changeCity(String city) async {
    final dataDecoded = await _weatherService.getWeatherByName(city);
    _updateData(dataDecoded);
    setState(() {
      _city = city;
    });
  }

  Future<void> _getCurrentPositionAndWeather() async {
    await _getCurrentPosition();
    await _getCityAndWeatherFromLatLong();
  }

  Future<void> _getCurrentPosition() async {
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _position = position;
      });
    } catch(e) {
      print('Current position is not available now');
      _changeCity('Moscow');
    }
  }

  Future<void> _getCityAndWeatherFromLatLong() async {
    if (_position == null) return;
    try {
      final place = await _locationService.getPlace(_position!);
      //get weather info
      final dataDecoded = await _weatherService.getWeatherByCoord(_position!);
      _updateData(dataDecoded);
      setState(() {
        _city = place.locality ?? '';
      });
    } catch (e) {
      print(e);
    }
  }

  void _updateData(weatherData) {
    setState(() {
      if (weatherData != null) {
        _temp = weatherData['main']['temp'].toInt();
        _icon = weatherData['weather'][0]['icon'];
        _desc = weatherData['main']['feels_like'].toString();
        _color = _getBackgroundColor(_temp);
      } else {
        _temp = 0;
        _city = 'In the middle of nowhere';
        _icon = '0';
      }
    });
  }

  Color _getBackgroundColor(int temp) {
    if (temp > Consts.hotTemperature) return Colors.orange;
    if (temp > Consts.warmTemperature) return Colors.yellow;
    if (temp <= Consts.coldTemperature) return Colors.blue;
    return Colors.white;
  }
}
