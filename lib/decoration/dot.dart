import 'package:bonfire/bonfire.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/util_spritesheet.dart';

class Dot extends GameDecoration with ObjectCollision {
  bool eated = false;
  Dot({
    required super.position,
  }) : super.withSprite(
          sprite: UtilSpriteSheet.dot,
          size: Vector2.all(12),
        ) {
    setupCollision(
      CollisionConfig(collisions: [
        CollisionArea.rectangle(
          size: Vector2.all(6),
          align: Vector2.all(2),
        ),
      ]),
    );
  }

  @override
  bool onCollision(GameComponent component, bool active) {
    if (component is PacMan && !eated) {
      eated = true;
      component.eatDot();
      removeFromParent();
    }
    return false;
  }

  @override
  int get priority => LayerPriority.MAP + 1;
}
