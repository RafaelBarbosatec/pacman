import 'package:bonfire/bonfire.dart';
import 'package:pacman/util/util_spritesheet.dart';

class Dot extends GameDecoration {
  bool eated = false;
  Dot({
    required super.position,
  }) : super.withSprite(
          sprite: UtilSpriteSheet.dot,
          size: Vector2.all(12),
        );

  @override
  int get priority => LayerPriority.MAP + 1;

}
