import 'package:flutter/material.dart';
import 'package:pacman/util/sounds.dart';

class GameState extends ChangeNotifier {
  final Duration _timePower = const Duration(seconds: 6);
  List<ValueChanged<bool>> onChangePowerObserves = [];
  Future? _powerTimer;

  int _score = 0;
  int _lifes = 3;
  bool _pacManWithPower = false;
  bool get pacManWithPower => _pacManWithPower;
  int get score => _score;
  int get lifes => _lifes;

  void incrementScore({int value = 10}) {
    _score += value;
    notifyListeners();
  }

  void decrementLife() {
    _lifes -= 1;
    notifyListeners();
  }

  void startPacManPower() {
    _powerTimer?.ignore();
    _pacManWithPower = true;
    for (var element in onChangePowerObserves) {
      element(_pacManWithPower);
    }
    Sounds.playPowerBackgroundSound();
    _powerTimer = Future.delayed(_timePower, () {
      _pacManWithPower = false;
      for (var element in onChangePowerObserves) {
        element(_pacManWithPower);
      }
      Sounds.stopBackgroundSound();
      notifyListeners();
    }).catchError((e) {});
    notifyListeners();
  }

  void listenChangePower(ValueChanged<bool> onChange) {
    onChangePowerObserves.add(onChange);
  }
}
