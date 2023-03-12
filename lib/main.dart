import 'package:flutter/material.dart';
import 'package:term_project_mobile/pages/home/home.page.dart';
import 'package:term_project_mobile/pages/login/login.page.dart';
import 'package:term_project_mobile/pages/main/main.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}
