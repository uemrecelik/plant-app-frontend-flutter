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

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImVtcmUiLCJzdWIiOjEsImlhdCI6MTY3ODIxNjQyNywiZXhwIjoxNjc4MjIwMDI3fQ.wE5QAmzBBq5fLeVvrghCfNQE3T71ZkZD1BkS64hqme8",
      };

  Future<User> fetchUser() async {
    var res = await http.get(dataUri, headers: headers);
    print(User.fromJson(jsonDecode(res.body)));
    return User.fromJson(jsonDecode(res.body));
  }

  Future fetchUsersPlants(User user) async {
    var res = await http.get(plantUri, headers: headers);
    final Map<String, dynamic> data = json.decode(res.body)[0];
    print(data);
  }
}
