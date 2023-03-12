import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:term_project_mobile/pages/home/TempProvider.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../entities/Sensor.dart';
import '../../../entities/User.dart';
import '../../login/login.servide.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    required this.image,
    required this.title,
    required this.country,
    required this.price,
    required this.sensorId,
  });

  final String image, title, country;
  final int price;
  final int sensorId;

  @override
  Widget build(BuildContext context) {
    TempProvider tempProvider =
        Provider.of<TempProvider>(context, listen: false);
    FlutterSecureStorage storage = LoginService().storage;

    Future<void> fethcSensor() async {
      final String? token = await storage.read(key: 'jwt');
      String url =
          'https://yu-term-project.herokuapp.com/sensor/plants-sensor?id=$sensorId';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<Sensor> sensorList =
          List<Map<String, dynamic>>.from(jsonDecode(response.body))
              .map((sensorJson) => Sensor.fromJson(sensorJson))
              .toList();
      int lastIndex = sensorList.length - 1;
      tempProvider.tempValue = sensorList[lastIndex].temperature;
      tempProvider.humValue = sensorList[lastIndex].humidity;
      tempProvider.plantName = title;
      tempProvider.optimumTemp = price.toString();
      tempProvider.optimumHum = country;
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: defaultPadding,
        top: defaultPadding / 2,
        bottom: defaultPadding * 2.5,
      ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Image.network(
            image,
            fit: BoxFit.fill,
            height: 150,
          ),
          GestureDetector(
            onTap: () {
              fethcSensor();
            },
            child: Container(
              padding: const EdgeInsets.all(defaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: deepGreenColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$country".toUpperCase(),
                          style: TextStyle(
                            color: deepGreenColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '$price',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: deepGreenColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
