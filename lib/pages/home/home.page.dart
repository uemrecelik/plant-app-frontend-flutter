import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:term_project_mobile/constants.dart';
import 'package:term_project_mobile/entities/Plant.dart';
import 'package:term_project_mobile/entities/User.dart';
import 'package:term_project_mobile/pages/home/home.service.dart';
import 'package:term_project_mobile/pages/home/sections/plantSlider.section.dart';
import 'package:term_project_mobile/pages/login/login.page.dart';
import 'package:term_project_mobile/pages/login/login.servide.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'TempProvider.dart';
import 'componets/graphCard.componet.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        ? const Center(child: CircularProgressIndicator())
        : ChangeNotifierProvider(
            create: (context) => TempProvider(),
            child: Consumer<TempProvider>(
              builder: (context, myProvider, child) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Welcome ${currentUser.username}'),
                    backgroundColor: deepGreenColor,
                    leading: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                      },
                    ),
                  ),
                  body: SafeArea(
                    child: Container(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  graphCard(
                                    value: myProvider.tempValue,
                                    isTemp: true,
                                  ),
                                  graphCard(
                                    value: myProvider.humValue,
                                    isTemp: false,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 145.0),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Selected Plant: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: darkGreyColor,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: myProvider.plantName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            deepGreenColor, // Change the color of the plantName value
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nOptimum Temperature: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: darkGreyColor),
                                    ),
                                    TextSpan(
                                      text: myProvider.optimumTemp,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .red, // Change the color of the optimumTemp value
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\nOptimum Humidity: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: darkGreyColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: myProvider.optimumHum,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .blue, // Change the color of the optimumHum value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            Container(
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
                            const SizedBox(
                              height: 10,
                            ),
                            PlantSlider(plantList: userPlants),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
