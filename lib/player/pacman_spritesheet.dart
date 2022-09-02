import 'package:bonfire/bonfire.dart';

class PacManSpriteSheet {
  static Future<SpriteAnimation> get idle => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
        ),
      );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
        ),
      );
  static Future<SpriteAnimation> get runUp => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 3,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(144, 0)),
      );
  static Future<SpriteAnimation> get runDown => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(288, 0),
        ),
      );

  static Future<SpriteAnimation> get die => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.3,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(0, 48),
        ),
      );
}
