import 'package:bonfire/bonfire.dart';
import 'package:avnetman/main.dart';

enum DiractionGate { left, right }

class SensorGate extends GameDecoration with Sensor {
  bool canMove = true;
  final DiractionGate direction;
  SensorGate({required super.position, this.direction = DiractionGate.left})
      : super(size: Vector2.all(Game.tileSize));

  @override
  void onContact(GameComponent component) {
  }

  @override
  void onContactExit(GameComponent component) {
    canMove = true;
  }
}
