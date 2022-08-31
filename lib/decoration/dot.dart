import 'package:bonfire/bonfire.dart';
import 'package:pacman/player/pacman_player.dart';
import 'package:pacman/util_spritesheet.dart';

class Dot extends GameDecoration with Sensor {
  Dot({
    required super.position,
  }) : super.withSprite(
          sprite: UtilSpriteSheet.dot,
          size: Vector2.all(12),
        ) {
    setupSensorArea(
      areaSensor: [
        CollisionArea.rectangle(
          size: Vector2.all(6),
          align: Vector2.all(2),
        ),
      ],
    );
  }

  @override
  void onContact(GameComponent component) {
    if (component is PacManPlayer) {
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {
    // TODO: implement onContactExit
  }
}
