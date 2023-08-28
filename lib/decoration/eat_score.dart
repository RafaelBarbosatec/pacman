import 'package:bonfire/bonfire.dart';
import 'package:pacman/main.dart';
import 'package:pacman/util/util_spritesheet.dart';

class EatScore extends GameDecoration with Movement, HandleForces {
  EatScore({
    required super.position,
  }) : super.withSprite(
          size: Vector2.all(Game.tileSize),
          sprite: UtilSpriteSheet.score100,
        ) {
    speed = 140;
    aboveComponents = true;
  }

  @override
  void update(double dt) {
    if (isStoped() && !isRemoving) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onMount() {
    addForce(ResistenceForce2D(id: 1, value: Vector2.all(2)));
    moveUp();
    super.onMount();
  }
}
