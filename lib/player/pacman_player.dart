import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/player/player_spritesheet.dart';

import '../main.dart';

class PacManPlayer extends SimplePlayer with ObjectCollision {
  bool withPower = false;
  bool youAreWinner = false;
  Future? _futurePowerTime;
  JoystickMoveDirectional _runDirection = JoystickMoveDirectional.IDLE;

  PacManPlayer({required super.position})
      : super(
          size: Vector2.all(Game.tileSize),
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.idle,
            runRight: PlayerSpriteSheet.runRight,
            runUp: PlayerSpriteSheet.runUp,
            runDown: PlayerSpriteSheet.runDown,
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

    movementByJoystickEnabled = false;
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (isDead) {
      return;
    }
    if (event.directional != JoystickMoveDirectional.IDLE &&
        event.directional != _runDirection) {
      Vector2 direction = Vector2.zero();
      switch (event.directional) {
        case JoystickMoveDirectional.MOVE_UP:
          direction = direction.translate(0, -20);
          break;
        case JoystickMoveDirectional.MOVE_UP_LEFT:
          direction = direction.translate(-20, 0);
          break;
        case JoystickMoveDirectional.MOVE_UP_RIGHT:
          direction = direction.translate(20, 0);
          break;
        case JoystickMoveDirectional.MOVE_RIGHT:
          direction = direction.translate(20, 0);
          break;
        case JoystickMoveDirectional.MOVE_DOWN:
          direction = direction.translate(0, 20);
          break;
        case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
          direction = direction.translate(20, 0);
          break;
        case JoystickMoveDirectional.MOVE_DOWN_LEFT:
          direction = direction.translate(-20, 0);
          break;
        case JoystickMoveDirectional.MOVE_LEFT:
          direction = direction.translate(-20, 0);
          break;
        case JoystickMoveDirectional.IDLE:
          break;
      }

      if (_canMove(direction)) {
        _runDirection = event.directional;
      }
    }
    super.joystickChangeDirectional(event);
  }

  @override
  void update(double dt) {
    bool move = false;
    switch (_runDirection) {
      case JoystickMoveDirectional.MOVE_UP:
        move = moveUp(speed);
        if (!move) {
          _correctPositionToCenterTile();
          move = moveUp(speed);
        }
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        move = moveLeft(speed);
        if (!move) {
          _correctPositionToCenterTile();
          move = moveLeft(speed);
        }
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        move = moveRight(speed);
        break;
      case JoystickMoveDirectional.MOVE_RIGHT:
        move = moveRight(speed);
        if (!move) {
          _correctPositionToCenterTile();
          move = moveRight(speed);
        }
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        move = moveDown(speed);
        if (!move) {
          _correctPositionToCenterTile();
          move = moveDown(speed);
        }
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        move = moveRight(speed);
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        move = moveLeft(speed);
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        move = moveLeft(speed);
        if (!move) {
          _correctPositionToCenterTile();
          move = moveLeft(speed);
        }
        break;
      case JoystickMoveDirectional.IDLE:
        idle();
        break;
    }

    if (!move) {
      _runDirection = JoystickMoveDirectional.IDLE;
      idle();
    }

    if (checkInterval('winner', 2000, dt) && !youAreWinner) {
      _checkIfWinenr();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    gameRef.camera.target = null;
    super.onMount();
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is Ghost) {
      return false;
    }
    return super.onCollision(component, active);
  }

  bool _canMove(Vector2 direction) {
    final v = gameRef.visibleCollisions().where((element) {
      return element.rectCollision.overlaps(
            rectCollision.deflate(10).translate(direction.x, direction.y),
          ) &&
          element != this;
    });

    return v.isEmpty;
  }

  void _correctPositionToCenterTile() {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = Vector2(w * Game.tileSize, h * Game.tileSize);
  }

  @override
  void die() {
    animation?.playOnce(
      PlayerSpriteSheet.die,
      onFinish: removeFromParent,
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

  void startPower() {
    withPower = true;
    _futurePowerTime?.ignore();
    _futurePowerTime = Future.delayed(const Duration(seconds: 5), () {
      withPower = false;
    }).catchError((e) {});
  }

  @override
  void idle() {
    _runDirection = JoystickMoveDirectional.IDLE;
    super.idle();
  }
}
