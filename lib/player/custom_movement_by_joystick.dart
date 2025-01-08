import 'package:bonfire/bonfire.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/main.dart';

mixin CustomMovementByJoystick on SimplePlayer {
  JoystickMoveDirectional _runDirection = JoystickMoveDirectional.IDLE;

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (isDead) {
      return;
    }
    if (event.directional != JoystickMoveDirectional.IDLE &&
        event.directional != _runDirection) {
      Direction newDirection = Direction.left;

      switch (event.directional) {
        case JoystickMoveDirectional.MOVE_UP:
          newDirection = Direction.up;
          break;
        case JoystickMoveDirectional.MOVE_DOWN_LEFT:
        case JoystickMoveDirectional.MOVE_LEFT:
        case JoystickMoveDirectional.MOVE_UP_LEFT:
          newDirection = Direction.left;
          break;
        case JoystickMoveDirectional.MOVE_UP_RIGHT:
        case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
        case JoystickMoveDirectional.MOVE_RIGHT:
          newDirection = Direction.right;
          break;

        case JoystickMoveDirectional.MOVE_DOWN:
          newDirection = Direction.down;
          break;
        case JoystickMoveDirectional.IDLE:
          return;
      }

      final dots = gameRef.collisions().where(
        (element) {
          return element.parent is Dot;
        },
      );

      if (canMove(newDirection,
          displacement: width / 2, ignoreHitboxes: dots)) {
        _correctPositionToCenterTile(
          x: newDirection.isVertical,
          y: newDirection.isHorizontal,
        );
        _runDirection = event.directional;
        super.onJoystickChangeDirectional(event);
      }
    }
  }

  void _correctPositionToCenterTile({bool x = true, bool y = true}) {
    int w = (position.x / Game.tileSize).round();
    int h = (position.y / Game.tileSize).round();
    position = position.copyWith(
      x: x ? w * Game.tileSize : null,
      y: y ? h * Game.tileSize : null,
    );
  }

  @override
  void idle() {
    _correctPositionToCenterTile();
    _runDirection = JoystickMoveDirectional.IDLE;
    super.idle();
  }
}
