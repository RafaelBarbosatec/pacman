import 'package:bonfire/bonfire.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/util_spritesheet.dart';

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
    if (component is PacMan) {
      component.eatDot();
      removeFromParent();
    }
  }

  @override
  int get priority => LayerPriority.MAP + 1;
}
