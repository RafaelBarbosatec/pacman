import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/player/custom_movement_by_joystick.dart';
import 'package:pacman/player/pacman_spritesheet.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';

import '../main.dart';

class PacMan extends SimplePlayer
    with ObjectCollision, CustomMovementByJoystick {
  static final Vector2 initialPosition = Vector2(
    9 * Game.tileSize,
    15 * Game.tileSize,
  );
  bool firstSoundMunch = false;
  bool youAreWinner = false;
  late GameState _gameState;
  async.Timer? _debounceSound;

  PacMan({required super.position})
      : super(
          size: Vector2.all(Game.tileSize),
          animation: SimpleDirectionAnimation(
            idleRight: PacManSpriteSheet.idle,
            runRight: PacManSpriteSheet.runRight,
            runUp: PacManSpriteSheet.runUp,
            enabledFlipY: true,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: size - Vector2.all(2),
            align: Vector2.all(1),
          ),
        ],
      ),
    );
  }

  @override
  void update(double dt) {
    if (checkInterval('winner', 1000, dt) && !youAreWinner) {
      _checkIfWinenr();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    _gameState = BonfireInjector.instance.get();
    gameRef.camera.target = null;
    gameRef.camera.moveLeft(Game.tileSize);
    super.onMount();
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is Ghost) {
      return false;
    }
    return super.onCollision(component, active);
  }

  @override
  void die() {
    Sounds.stopBackgroundSound();
    Sounds.death();
    _gameState.decrementLife();
    animation?.playOnce(
      PacManSpriteSheet.die,
      onFinish: () {
        if (_gameState.lifes == 0) {
          removeFromParent();
        } else {
          position = initialPosition;
          idle();
          revive();
        }
      },
      runToTheEnd: true,
    );
    super.die();
  }

  void _checkIfWinenr() {
    bool winner = gameRef.componentsByType<Dot>().isEmpty;
    if (winner) {
      youAreWinner = true;
      print('PARABENS VC GANHOU !!');
    }
  }

  void eatDot() {
    debounce(() {
      Sounds.munch(first: firstSoundMunch);
      firstSoundMunch = !firstSoundMunch;
    });
    _gameState.incrementScore();
  }

  void debounce(VoidCallback call) {
    if (_debounceSound?.isActive ?? false) {
      return;
    }
    _debounceSound = async.Timer(Duration.zero, call);
  }
}
