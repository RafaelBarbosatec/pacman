import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/decoration/eat_score.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/player/custom_movement_by_joystick.dart';
import 'package:pacman/player/pacman_spritesheet.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';
import 'package:pacman/widgets/congratulation_dialog.dart';
import 'package:pacman/widgets/game_over_dialog.dart';

import '../main.dart';

class PacMan extends SimplePlayer
    with ObjectCollision, Sensor, CustomMovementByJoystick {
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

    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: size - Vector2.all(24),
          align: Vector2.all(12),
        ),
      ],
      intervalCheck: 150,
    );
  }

  @override
  void update(double dt) {
    _checkIfWinner(dt);
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
          async.Future.delayed(Duration.zero, () {
            GameOverDialog.show(context);
            removeFromParent();
          });
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

  void _checkIfWinner(double dt) {
    if (checkInterval('winner', 1000, dt) && !youAreWinner) {
      bool winner = gameRef.componentsByType<Dot>().isEmpty;
      if (winner) {
        youAreWinner = true;
        CongratulationsDialog.show(context);
      }
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
    _debounceSound = async.Timer(const Duration(milliseconds: 100), call);
  }

  @override
  void onContact(GameComponent component) {
    if (component is Dot && !component.eated) {
      component.eated = true;
      eatDot();
      component.removeFromParent();
    }
    if (component is Ghost) {
      if (component.state == GhostState.vulnerable) {
        _incrementScore();
        component.bite();
      } else if (component.state == GhostState.normal) {
        if (!isDead) {
          idle();
          die();
        }
      }
    }
  }

  void _incrementScore() {
    gameRef.add(EatScore(position: position));
    _gameState.incrementScore(value: 200);
  }
}
