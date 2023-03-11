import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:term_project_mobile/entities/Plant.dart';
import '../../entities/User.dart';
import '../login/login.servide.dart';
import 'package:http/http.dart' as http;

class HomeService {
  FlutterSecureStorage storage = LoginService().storage;
  final dataUri = Uri.https('yu-term-project.herokuapp.com', '/user/user-info');
  final plantUri = Uri.https('yu-term-project.herokuapp.com', '/plants');
  late User user;
  late List plants;
  late Plant plant;

  Future<User> fetchUser() async {
    final String? token = await storage.read(key: 'jwt');
    String url = 'https://yu-term-project.herokuapp.com/user/user-info';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final User user = User.fromJson(jsonDecode(response.body));
    return user;
  }

  Future<List> fetchPlants(User user) async {
    final String? jwt = await storage.read(key: 'jwt');
    String url = 'https://yu-term-project.herokuapp.com/plants';
    String? token = jwt;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    return List<Map<String, dynamic>>.from(jsonDecode(response.body))
        .map((plantJson) => Plant.fromJson(plantJson))
        .toList();
  }
}
