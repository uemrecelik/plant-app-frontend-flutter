import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../entities/Plant.dart';
import '../../entities/Sensor.dart';
import '../../entities/User.dart';
import 'package:http/http.dart' as http;

import '../home/home.service.dart';
import 'notification.service.dart';

class MainService {
  late User currentUser;
  late List<Plant> userPlants;
  late List<Plant> plants;

  FlutterSecureStorage storage = const FlutterSecureStorage();

  void checkForNotification() async {
    currentUser = await getCurrentUser();
    plants = await getUserPlants(currentUser);
    List<Sensor> latestSensorData = await fethcSensor();

    plants.forEach((plant) {
      latestSensorData.forEach((sensor) {
        if (plant.id == sensor.plantId) {
          if (sensor.temperature < plant.optimumTemp) {
            var criticalTemp = sensor.temperature;
            var criticalPlant = plant.name;
            NotificationService().showNotification(
                title: 'Low Temprature for : $criticalPlant',
                body:
                    'Your temperature level is critical. Current temperature is: $criticalTemp .Do you Want to check with roboat ?');
          }
          if (sensor.humidity < plant.optimumHum) {
            var criticalHum = sensor.humidity;
            var criticalPlant = plant.name;
            NotificationService().showNotification(
                title: 'Low Humidity for : $criticalPlant',
                body:
                    'Your humidity level is critical. Current humidity is: $criticalHum .Do you Want to check with roboat ?');
          }
        }
      });
    });
  }

  Future<User> getCurrentUser() async {
    User user = await HomeService().fetchUser();
    return user;
  }

  Future<List<Plant>> getUserPlants(user) async {
    userPlants = await HomeService().fetchPlants(user) as List<Plant>;
    return userPlants;
  }

  Future<List<Sensor>> fethcSensor() async {
    final String? token = await storage.read(key: 'jwt');
    var userId = currentUser.userId;
    String url =
        'https://yu-term-project.herokuapp.com/sensor/check-notification?userId=$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return List<Map<String, dynamic>>.from(jsonDecode(response.body))
        .map((sensorJson) => Sensor.fromJson(sensorJson))
        .toList();
  }
}
