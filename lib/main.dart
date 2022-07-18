import 'dart:convert';

import 'package:flutter/material.dart';
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

  getWeather() async {
    var apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=31&lon=74&appid=dbbb70b17c9af09d1086361061f9d7be';
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
                getWeather();
              },
              child: Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}
