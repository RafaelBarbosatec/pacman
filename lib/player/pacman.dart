import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/decoration/dot_power.dart';
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
    with BlockMovementCollision, CustomMovementByJoystick {
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
          speed: 100,
        );

  @override
  Future<void> onLoad() {
    final s = size / 1.2;
    add(
      RectangleHitbox(
        size: s,
        position: (size - s) / 2,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _checkIfWinner(dt);
    super.update(dt);
  }

  @override
  void onMount() {
    _gameState = GameState();
    gameRef.camera.stop();
    super.onMount();
  }

  @override
  void die() {
    super.die();
    stopMove(forceIdle: true);
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
          stopMove(forceIdle: true);
          revive();
        }
      },
      runToTheEnd: true,
    );
  }

  void _checkIfWinner(double dt) {
    if (checkInterval('winner', 1000, dt) && !youAreWinner) {
      bool winner = gameRef.query<Dot>().isEmpty;
      if (winner) {
        youAreWinner = true;
        CongratulationsDialog.show(context);
      }
    }
  }

  void eatDot() {
    // debounce(() {
    //   Sounds.munch(first: firstSoundMunch);
    //   firstSoundMunch = !firstSoundMunch;
    // });
    _gameState.incrementScore();
  }

  void debounce(VoidCallback call) {
    if (_debounceSound?.isActive ?? false) {
      return;
    }
    _debounceSound = async.Timer(const Duration(milliseconds: 100), call);
  }

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    _handleContact(other);
    if (other is Dot ||
        other is DotPower ||
        (other is Ghost && other.state != GhostState.normal)) {
      return false;
    }
    stopMove();
    return super.onBlockMovement(intersectionPoints, other);
  }

  void _incrementScore() {
    gameRef.add(EatScore(position: position));
    _gameState.incrementScore(value: 200);
  }

  void _handleContact(GameComponent component) {
    if (component is Dot && !component.eated) {
      component.eated = true;
      eatDot();
      component.removeFromParent();
    }
    if (component is Ghost && !isDead && component.state != GhostState.die) {
      if (component.state == GhostState.vulnerable) {
        component.bite();
        _incrementScore();
      } else if (component.state == GhostState.normal && !isDead) {
        die();
      }
    }
  }
}
