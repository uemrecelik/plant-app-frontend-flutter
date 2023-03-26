import 'dart:async';

import 'package:flutter/material.dart';
import 'package:term_project_mobile/pages/graph/graph.page.dart';
import 'package:term_project_mobile/pages/home/home.page.dart';
import 'package:term_project_mobile/pages/main/main.service.dart';
import 'package:term_project_mobile/pages/robot/robot.page.dart';
import 'package:term_project_mobile/pages/user/user.page.dart';

import 'notification.service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      MainService().checkForNotification();
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    GraphPage(),
    RobotPage(),
    UserPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'Robot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
      ),
    );
  }
}
