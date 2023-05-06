import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:roslib/roslib.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../entities/Plant.dart';
import '../../entities/Sensor.dart';
import '../../entities/User.dart';
import '../home/home.service.dart';

class RobotPage extends StatefulWidget {
  const RobotPage({Key? key});

  @override
  State<RobotPage> createState() => _RobotPageState();
}

class _RobotPageState extends State<RobotPage> {
  late Ros ros;
  late Topic cmdVel;
  late Topic testStdMessage;
  late Topic poseMsg;
  late User currentUser;
  late List<Plant> userPlants;
  late List<Plant> plants;
  bool isLoaded = false;

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getPlantData();

    // Initialize ROSBridge client
    ros = Ros(url: 'ws://172.20.10.7:9090');
    ros.connect();

    // Set up topic for sending commands
    cmdVel = Topic(
      ros: ros,
      name: 'turtle1/cmd_vel',
      type: 'geometry_msgs/Twist',
    );
    poseMsg = Topic(
      ros: ros,
      name: '/words',
      type: 'geometry_msgs/Pose',
    );

    testStdMessage = Topic(
      ros: ros,
      name: '/words',
      type: 'std_msgs/String',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getPlantData() async {
    currentUser = await getCurrentUser();
    plants = await getUserPlants(currentUser);
    List<Sensor> latestSensorData = await fethcSensor();
    plants.forEach((plant) {
      latestSensorData.forEach((sensor) {
        if (plant.id == sensor.plantId) {
          if (sensor.temperature < plant.optimumTemp) {
            var criticalTemp = sensor.temperature;
            var criticalPlant = plant.name;
            plant.isCritical = true;
          }
          if (sensor.humidity < plant.optimumHum) {
            var criticalHum = sensor.humidity;
            var criticalPlant = plant.name;
            plant.isCritical = true;
          }
        }
      });
    });
    setState(() {
      isLoaded = true;
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

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text('Robot Control'),
              backgroundColor: deepGreenColor,
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("lib/assets/map2.png"),
                              fit: BoxFit.cover)),
                      height: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.grey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: buildPlantStatusWidgets(userPlants),
                  ),
                  Text(ros.url),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                    ),
                    child: Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userPlants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Map<String, dynamic> json = {"data": '0,0'};
                              print(json);
                              json['data'] = userPlants[index].position;
                              testStdMessage.publish(json);
                              print(json);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                width: 85,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: userPlants[index].isCritical
                                        ? Colors.red
                                        : Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userPlants[index].imageUrl),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Column buildPlantStatusWidgets(List<Plant> userPlants) {
  List<Widget> plantStatusWidgets = [];

  for (var element in userPlants) {
    var name = element.name;
    if (element.isCritical) {
      plantStatusWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 5.0),
              Text(
                '$name is critical',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      plantStatusWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            children: [
              Text(
                '$name is fine',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              Icon(
                Icons.check,
                color: Colors.green,
              ),
            ],
          ),
        ),
      );
    }
  }

  return Column(children: plantStatusWidgets);
}
