import 'dart:async';

import 'package:flutter/material.dart';
import 'package:avnetman/enemy/ghost_spritesheet.dart';
import 'package:avnetman/util/sounds.dart';

class GameState extends ChangeNotifier {
  final Duration _timePower = const Duration(seconds: 10);
  List<ValueChanged<bool>> onChangePowerObserves = [];
  late Timer _powerTimer = Timer(const Duration(days: 40000), () {});

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

  void decrementScore(int value) {
    _score -= value;
    notifyListeners();
  }

  void decrementLife() {
    _lifes -= 1;
    notifyListeners();
  }

  void startPacManPower() {
    _powerTimer.cancel();
    _pacManWithPower = true;
    for (var element in onChangePowerObserves) {
      element(_pacManWithPower);
    }
    Sounds.playPowerBackgroundSound();
    _powerTimer = Timer(_timePower, () {
      _pacManWithPower = false;
      for (var element in onChangePowerObserves) {
        element(_pacManWithPower);
      }
      Sounds.stopBackgroundSound();
      notifyListeners();
    });
    notifyListeners();
  }

  void listenChangePower(ValueChanged<bool> onChange) {
    onChangePowerObserves.add(onChange);
  }

  void reset() {
    _score = 0;
    _lifes = 3;
    onChangePowerObserves.clear();
    _powerTimer.cancel();
    GhostSpriteSheet.reshuffle();
  }
}
