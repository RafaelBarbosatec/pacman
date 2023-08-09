import 'package:bonfire/bonfire.dart';

class UtilSpriteSheet {
  static Future<Sprite> dot = Sprite.load('dot.png');

  static Future<SpriteAnimation> get dotPower => SpriteAnimation.load(
        'dot_power.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.4,
          textureSize: Vector2.all(48),
        ),
      );

  static Future<Sprite> get score100 => Sprite.load('empty.png',
      srcSize: Vector2.all(48));

  static Future<Sprite> get pacman => Sprite.load('empty.png',
      srcSize: Vector2.all(48));
}
