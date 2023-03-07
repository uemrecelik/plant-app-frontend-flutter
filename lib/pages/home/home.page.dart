import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:term_project_mobile/entities/Plant.dart';
import 'package:term_project_mobile/entities/User.dart';
import 'package:term_project_mobile/pages/home/home.service.dart';
import 'package:term_project_mobile/pages/home/sections/plantSlider.section.dart';
import 'package:term_project_mobile/pages/login/login.servide.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    currentUser = await HomeService().fetchUser();
    getUserPlants();
  }

  void getUserPlants() async {
    HomeService().fetchUsersPlants(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Column(
        children: [
          PlantSlider(),
        ],
      ),
    )));
  }
}
