import 'package:bonfire/bonfire.dart';
import 'package:avnetman/util/util_spritesheet.dart';

class Dot extends GameDecoration {
  bool eated = false;
  Dot({
    required super.position,
  }) : super.withSprite(
          sprite: UtilSpriteSheet.dot,
          size: Vector2.all(48),
        );

  @override
  int get priority => LayerPriority.MAP + 1;

}
