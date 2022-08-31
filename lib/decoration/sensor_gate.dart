import 'package:bonfire/bonfire.dart';
import 'package:pacman/main.dart';

enum DiractionGate { left, right }

class SensorGate extends GameDecoration with Sensor {
  bool canMove = true;
  final DiractionGate direction;
  SensorGate({required super.position, this.direction = DiractionGate.left})
      : super(size: Vector2.all(Game.tileSize));

  @override
  void onContact(GameComponent component) {
    if (canMove) {
      canMove = false;
      switch (direction) {
        case DiractionGate.left:
          component.position = component.position.copyWith(
            x: 18 * Game.tileSize,
          );
          break;
        case DiractionGate.right:
          component.position = component.position.copyWith(
            x: 0,
          );
          break;
      }
    }
  }

  @override
  void onContactExit(GameComponent component) {
    canMove = true;
  }
}
