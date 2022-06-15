import 'package:flutter/material.dart';

class SchemeProvider extends ChangeNotifier {
  int? _currentSchemeId;

  int? get currentSchemeId => _currentSchemeId;

  void setCurrentSchemeId(int? newVal) {
    _currentSchemeId = newVal;
    notifyListeners();
  }

}