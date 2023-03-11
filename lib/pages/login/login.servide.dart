import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginService {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  final loginUri = Uri.https('yu-term-project.herokuapp.com', '/user/login');

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Future attemptLogIn(String username, String password) async {
    var res = await http
        .post(loginUri, body: {"username": username, "password": password});
    if (res.statusCode == 200 || res.statusCode == 201) {
      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      String accessToken = jsonMap['access_token'];
      storage.write(key: "jwt", value: accessToken);
      return res.body;
    }
    return null;
  }
}
