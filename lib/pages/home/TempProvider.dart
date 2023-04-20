import 'package:flutter/material.dart';

class TempProvider extends ChangeNotifier {
  int _tempValue = 0;
  int _humValue = 0;
  String _plantName = 'Select Plant';
  String _optimumTemp = '';
  String _optimumHum = '';
  String _latestUpdateDate = '';

  int get tempValue => _tempValue;
  int get humValue => _humValue;
  String get plantName => _plantName;
  String get optimumTemp => _optimumTemp;
  String get optimumHum => _optimumHum;
  String get latestUpdateDate => _latestUpdateDate;

  set tempValue(int value) {
    _tempValue = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }

  set humValue(int value) {
    _humValue = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }

  set plantName(String value) {
    _plantName = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }

  set optimumHum(String value) {
    _optimumHum = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }

  set optimumTemp(String value) {
    _optimumTemp = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }

  set latestUpdateDate(String value) {
    _latestUpdateDate = value;
    notifyListeners(); // Notify any listeners that the value has changed
  }
}
