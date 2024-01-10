import 'dart:async' as async;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:avnetman/decoration/dot.dart';
import 'package:avnetman/decoration/eat_score.dart';
import 'package:avnetman/enemy/ghost.dart';
import 'package:avnetman/player/custom_movement_by_joystick.dart';
import 'package:avnetman/player/pacman_spritesheet.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:avnetman/util/sounds.dart';
import 'package:avnetman/widgets/congratulation_dialog.dart';
import 'package:avnetman/widgets/game_over_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../main.dart';

class PacMan extends SimplePlayer
    with ObjectCollision, Sensor, CustomMovementByJoystick {
  static final Vector2 initialPosition = Vector2(
    8 * Game.tileSize,
    15 * Game.tileSize,
  );
  bool firstSoundMunch = false;
  bool youAreWinner = false;
  late GameState _gameState;
  async.Timer? _debounceSound;

final textBubble = const Text('Ready for business!',
      style: TextStyle(
          inherit: false,
          fontSize: 60.0,
          color: Colors.green,
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.5, -1.5),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.5, -1.5),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.5),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.5, 1.5),
                color: Colors.black),
          ]),
      textAlign: TextAlign.center);

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
    _gameState.listenChangePower(_pacManChangePower);
    gameRef.camera.moveToTargetAnimated(gameRef.camera.target!, zoom: gameRef.camera.zoom - 0.2);
    super.onMount();
  }

  void _pacManChangePower(bool value) {
    if (value) {
      FollowerWidget.show(
        identify: 'textBubble',
        context: context,
        target: this,
        child: textBubble
            .animate()
            .fadeIn(duration: Duration(seconds: 1)).then()
            .shimmer(duration: Duration(seconds: 8)).shakeX(duration: Duration(seconds: 8), hz: 0.5, amount: 10.0).then()
            .fadeOut(duration: Duration(seconds: 1)),
        align: const Offset(-40.0, -40.0),
      );
    } else {
      FollowerWidget.remove('textBubble');
    }
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
    if (youAreWinner) return;
    Sounds.stopBackgroundSound();
    Sounds.death();
    FollowerWidget.remove('textBubble');
    _gameState.decrementLife();
    _gameState.decrementScore(500);
    animation?.playOnce(
      PacManSpriteSheet.die,
      onFinish: () {
        if (_gameState.lifes == 0) {
          async.Future.delayed(Duration.zero, () {
            gameRef.camera.moveToTargetAnimated(gameRef.camera.target!, zoom: 0.00001);
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
      bool winner =  gameRef.componentsByType<Dot>().isEmpty;
      if (winner) {
        gameRef.camera.moveToTargetAnimated(gameRef.camera.target!, zoom: 0.00001);
        youAreWinner = true;
        FollowerWidget.remove('textBubble');
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
