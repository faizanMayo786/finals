import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWeatherApp(),
    );
  }
}

class MyWeatherApp extends StatefulWidget {
  MyWeatherApp({Key? key}) : super(key: key);

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  String temp = '';

  String locationName = '';

  String countryCode = '';

  String weatherConditions = '';

  Position? currentPosition;
  @override
  initState() {
    super.initState();
    _determinePosition();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getWeather(currentPosition!.latitude, currentPosition!.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request for permission anymore');
    }
    return await Geolocator.getCurrentPosition();
  }

  getWeather(double lat, double lon) async {
    var apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=d29bf9f414cd29a6c433123319353ccb';
    var response = await http.get(Uri.parse(apiUrl));
    dynamic data = jsonDecode(response.body);
    setState(() {
      temp = data['main']['temp'].toString();
      locationName = data['name'];
      countryCode = data['sys']['country'];
      weatherConditions = data['weather'][0]['description'];
    });
    // print(data['weather'][0]['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Updates'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Temperature:\t$temp'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Area Name:\t$locationName'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Country:\t$countryCode'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Weather Condition:\t$weatherConditions'),
            ),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
