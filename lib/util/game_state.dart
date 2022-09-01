import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  final Duration _timePower = const Duration(seconds: 6);
  List<ValueChanged<bool>> onChangePowerObserves = [];
  Future? _powerTimer;

  int _score = 0;
  bool _pacManWithPower = false;
  bool get pacManWithPower => _pacManWithPower;
  int get score => _score;

  void upateScore({int value = 100}) {
    _score = value;
  }

  void startPacManPower() {
    _powerTimer?.ignore();
    _pacManWithPower = true;
    for (var element in onChangePowerObserves) {
      element(_pacManWithPower);
    }
    _powerTimer = Future.delayed(_timePower, () {
      _pacManWithPower = false;
      for (var element in onChangePowerObserves) {
        element(_pacManWithPower);
      }
      notifyListeners();
    }).catchError((e) {});
    notifyListeners();
  }

  void listenChangePower(ValueChanged<bool> onChange) {
    onChangePowerObserves.add(onChange);
  }
}
