import 'package:bonfire/bonfire.dart';
import 'package:avnetman/enemy/ghost.dart';

var _red_asset = GhostSpriteSheet.get_random_ghost();
var _blue_asset = GhostSpriteSheet.get_random_ghost();
var _pink_asset = GhostSpriteSheet.get_random_ghost();
var _orange_asset = GhostSpriteSheet.get_random_ghost();

var avaiable = ['ghost_0.png', 'ghost_1.png', 'ghost_2.png', 'ghost_3.png', 'ghost_4.png', 'ghost_5.png', 'ghost_6.png'];
var stillUpForGrab = List.from(avaiable);

class GhostSpriteSheet {

  static String get_random_ghost() {
    var item = (stillUpForGrab..shuffle()).first;
    stillUpForGrab.remove(item);
    return item;
  }

  static reshuffle() {
    stillUpForGrab = List.from(avaiable);
    _red_asset = GhostSpriteSheet.get_random_ghost();
    _blue_asset = GhostSpriteSheet.get_random_ghost();
    _pink_asset = GhostSpriteSheet.get_random_ghost();
    _orange_asset = GhostSpriteSheet.get_random_ghost();
  }

  static Future<SpriteAnimation> get red => SpriteAnimation.load(
        _red_asset,
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.06, textureSize: Vector2.all(48)),
      );


  static Future<SpriteAnimation> get pink => SpriteAnimation.load(
        _pink_asset,
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.5, textureSize: Vector2.all(48)),
      );


  static Future<SpriteAnimation> get blue => SpriteAnimation.load(
        _blue_asset,
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.5, textureSize: Vector2.all(48)),
      );


  static Future<SpriteAnimation> get orange => SpriteAnimation.load(
        _orange_asset,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.4,
          textureSize: Vector2.all(48),
        ),
      );

  static Future<SpriteAnimation> get runPower => SpriteAnimation.load(
        'die.png',
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.5,
          textureSize: Vector2.all(48),
        ),
      );

  static Future<SpriteAnimation> get runEyes => SpriteAnimation.load(
        'eyes.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.7,
          textureSize: Vector2.all(48)
        ),
      );

  static SimpleDirectionAnimation getByType(GhostType type) {
    switch (type) {
      case GhostType.red:
        return SimpleDirectionAnimation(
          idleRight: red,
          runRight: red,
          runUp: red,
          runDown: red,
        );
      case GhostType.blue:
        return SimpleDirectionAnimation(
          idleRight: blue,
          runRight: blue,
          runUp: blue,
          runDown: blue,
        );
      case GhostType.pink:
        return SimpleDirectionAnimation(
          idleRight: pink,
          runRight: pink,
          runUp: pink,
          runDown: pink,
        );
      case GhostType.orange:
        return SimpleDirectionAnimation(
          idleRight: orange,
          runRight: orange,
          runUp: orange,
          runDown: orange,
        );
    }
  }
}
