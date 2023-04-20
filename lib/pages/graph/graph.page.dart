import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:term_project_mobile/entities/GraphData.dart';
import 'package:term_project_mobile/pages/graph/plantGraph.component.dart';

import '../../constants.dart';
import '../../entities/Plant.dart';
import '../../entities/User.dart';
import '../home/home.service.dart';
import '../login/login.page.dart';
import '../login/login.servide.dart';
import 'package:http/http.dart' as http;

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late User currentUser;
  late List<Plant> userPlants;
  bool isLoading = true;
  String selectedOption1 = 'Tomato';
  String selectedOption2 = 'Hour';
  List<String> items1 = ['Tomato', 'Onion'];
  List<String> items2 = ['Hourly', 'Daily', 'Weekly', 'Monthly'];
  bool isDropdown1Enabled = false;
  List<GraphData> graphData = [];
  FlutterSecureStorage storage = LoginService().storage;
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
      items1 = userPlants.map((e) => e.name).toList();
      items2 = ['Hourly', 'Daily', 'Weekly', 'Monthly'];
      selectedOption1 = items1.first;
      selectedOption2 = items2.first;
      isLoading = false;
    });
  }

  void getGraphData(String param1, String param2) async {
    setState(() {
      isLoading = true;
    });
    final String? token = await storage.read(key: 'jwt');
    String url =
        'https://yu-term-project.herokuapp.com/graph?plant=$param1&date=$param2';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    List<GraphData> sensorList =
        List<Map<String, dynamic>>.from(jsonDecode(response.body))
            .map((sensorJson) => GraphData.fromJson(sensorJson))
            .toList();

    setState(() {
      graphData = sensorList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Deep Dive Anlyses'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        DropdownButton<String>(
                          value: selectedOption1,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption1 = newValue!;
                              isDropdown1Enabled = true;
                            });
                          },
                          hint: Text('Select a plant'),
                          items: items1
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        DropdownButton<String>(
                          value: selectedOption2,
                          onChanged: isDropdown1Enabled
                              ? (String? newValue) {
                                  setState(() {
                                    selectedOption2 = newValue!;
                                  });
                                  getGraphData(
                                      selectedOption1, selectedOption2);
                                }
                              : null,
                          hint: Text('Select a date interval'),
                          items: items2
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: PlantGraph(
                    graphDataList: graphData,
                    plant: selectedOption1,
                    title: selectedOption2,
                  )),
                ],
              ),
            ),
          );
  }
}
