import 'package:bonfire/bonfire.dart';

class PacManSpriteSheet {
  static Future<SpriteAnimation> get idle => SpriteAnimation.load(
        'pavnet_man.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.05,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        'pavnet_man.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.05,
          textureSize: Vector2.all(48),
        ),
      );
  static Future<SpriteAnimation> get runUp => SpriteAnimation.load(
        'pavnet_man.png',
        SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.05,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(288, 0)),
      );
  static Future<SpriteAnimation> get runDown => SpriteAnimation.load(
        'pavnet_man.png',
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.05,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(576, 0),
        ),
      );

  static Future<SpriteAnimation> get die => SpriteAnimation.load(
        'char_die.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.08,
          textureSize: Vector2.all(48)
        ),
      );
}
