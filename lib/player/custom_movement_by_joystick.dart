import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/main.dart';
// import 'package:pacman/enemy/ghost.dart';
// import 'package:pacman/main.dart';

mixin CustomMovementByJoystick on SimplePlayer {
  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional == JoystickMoveDirectional.IDLE) {
      return;
    }
    if (!_canMove(event.directional)) {
      return;
    }
    _correctPositionToCenterTile();
    super.joystickChangeDirectional(event);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Tile) {
      super.joystickChangeDirectional(
        JoystickDirectionalEvent(directional: JoystickMoveDirectional.IDLE),
      );
    }

    super.onCollision(intersectionPoints, other);
  }

  bool _canMove(JoystickMoveDirectional move) {
    final direction = _getDirectionOfMovement(move);

    final v = gameRef.collisions().where((element) {
      return element.toAbsoluteRect().overlaps(
                rectCollision.deflate(5).translate(direction.x, direction.y),
              ) &&
          element.parent != this &&
          element.parent is! Dot &&
          element.parent is! Ghost;
    });
    return v.isEmpty;
  }

  Vector2 _getDirectionOfMovement(JoystickMoveDirectional move) {
    Vector2 direction = Vector2.zero();
    switch (move) {
      case JoystickMoveDirectional.MOVE_UP:
        direction = direction.translated(0, -20);
        break;
      case JoystickMoveDirectional.MOVE_UP_LEFT:
        direction = direction.translated(-20, 0);
        break;
      case JoystickMoveDirectional.MOVE_UP_RIGHT:
        direction = direction.translated(20, 0);
        break;
      case JoystickMoveDirectional.MOVE_RIGHT:
        direction = direction.translated(20, 0);
        break;
      case JoystickMoveDirectional.MOVE_DOWN:
        direction = direction.translated(0, 20);
        break;
      case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        direction = direction.translated(20, 0);
        break;
      case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        direction = direction.translated(-20, 0);
        break;
      case JoystickMoveDirectional.MOVE_LEFT:
        direction = direction.translated(-20, 0);
        break;
      case JoystickMoveDirectional.IDLE:
        break;
    }
    return direction;
  }

  void _correctPositionToCenterTile() {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = Vector2(w * Game.tileSize, h * Game.tileSize);
  }
}
