import 'package:bonfire/bonfire.dart';
import 'package:pacman/enemy/ghost.dart';

class GhostSpriteSheet {
  static Future<SpriteAnimation> get runRightRed => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 6, 48 * 2)),
      );

  static Future<SpriteAnimation> get runUpRed => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 2, 48 * 2)),
      );

  static Future<SpriteAnimation> get runDownRed => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(0, 48 * 2)),
      );

  static Future<SpriteAnimation> get runRightPink => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 6, 48 * 3)),
      );

  static Future<SpriteAnimation> get runUpPink => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 2, 48 * 3)),
      );

  static Future<SpriteAnimation> get runRightBlue => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 6, 48 * 4)),
      );

  static Future<SpriteAnimation> get runUpBlue => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.1,
            textureSize: Vector2.all(48),
            texturePosition: Vector2(48 * 2, 48 * 4)),
      );

  static Future<SpriteAnimation> get runRightOrange => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(48 * 6, 48 * 5),
        ),
      );

  static Future<SpriteAnimation> get runUpOrange => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(48 * 2, 48 * 5),
        ),
      );
  static Future<SpriteAnimation> get runPower => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(0, 48 * 6),
        ),
      );

      static Future<SpriteAnimation> get runEyes => SpriteAnimation.load(
        'pacman-sprites.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2.all(48),
          texturePosition: Vector2(0, 48 * 7),
        ),
      );

  static SimpleDirectionAnimation getByType(GhostType type) {
    switch (type) {
      case GhostType.red:
        return SimpleDirectionAnimation(
          idleRight: runRightRed,
          runRight: runRightRed,
          runUp: runUpRed,
          runDown: runDownRed,
        );
      case GhostType.blue:
        return SimpleDirectionAnimation(
          idleRight: runRightBlue,
          runRight: runRightBlue,
          runUp: runUpBlue,
        );
      case GhostType.pink:
        return SimpleDirectionAnimation(
          idleRight: runRightPink,
          runRight: runRightPink,
          runUp: runUpPink,
        );
      case GhostType.orange:
        return SimpleDirectionAnimation(
          idleRight: runRightOrange,
          runRight: runRightOrange,
          runUp: runUpOrange,
        );
    }
  }
}
