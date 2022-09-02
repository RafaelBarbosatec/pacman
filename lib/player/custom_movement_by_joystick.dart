import 'package:bonfire/bonfire.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/main.dart';

mixin CustomMovementByJoystick on SimplePlayer {
  JoystickMoveDirectional _runDirection = JoystickMoveDirectional.IDLE;

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
      idle();
    }

    super.update(dt);
  }

  bool _canMove(Vector2 direction) {
    final v = gameRef.visibleCollisions().where((element) {
      return element.rectCollision.overlaps(
            (this as ObjectCollision)
                .rectCollision
                .deflate(14)
                .translate(direction.x, direction.y),
          ) &&
          element != this &&
          element is! Ghost;
    });

    return v.isEmpty;
  }

  void _correctPositionToCenterTile() {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = Vector2(w * Game.tileSize, h * Game.tileSize);
  }

  @override
  void idle() {
    _runDirection = JoystickMoveDirectional.IDLE;
    super.idle();
  }

  @override
  void onMount() {
    movementByJoystickEnabled = false;
    super.onMount();
  }
}
