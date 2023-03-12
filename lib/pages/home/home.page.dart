import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:term_project_mobile/entities/Plant.dart';
import 'package:term_project_mobile/entities/User.dart';
import 'package:term_project_mobile/pages/home/home.service.dart';
import 'package:term_project_mobile/pages/home/sections/plantSlider.section.dart';
import 'package:term_project_mobile/pages/login/login.servide.dart';
import 'package:http/http.dart' as http;

import 'componets/graphCard.componet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User currentUser;
  late List<Plant> userPlants;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    currentUser = await HomeService().fetchUser();
    getUserPlants(currentUser);
  }

  void getUserPlants(user) async {
    userPlants = await HomeService().fetchPlants(user) as List<Plant>;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
                child: Container(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        graphCard(value: 60, isTemp: true),
                        graphCard(value: 20, isTemp: false)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PlantSlider(plantList: userPlants),
                ],
              ),
            ),
          )));
  }
}
