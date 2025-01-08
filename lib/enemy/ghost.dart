import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/enemy/ghost_spritesheet.dart';
import 'package:pacman/main.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/game_state.dart';
import 'package:pacman/util/sounds.dart';
import 'package:provider/provider.dart';

enum GhostType { red, blue, pink, orange }

enum GhostState { normal, vulnerable, die }

class Ghost extends SimpleEnemy with BlockMovementCollision, PathFinding {
  static const normalSpeed = 140.0;
  static const vulnerableSpeed = 90.0;
  static const dieSpeed = 240.0;
  GhostState state = GhostState.normal;
  final Vector2 _startPositionAfterDie = Vector2(
    Game.tileSize * 9,
    Game.tileSize * 9,
  );
  late GameState _gameState;
  final GhostType type;

  bool enabledBeheavor = false;
  Ghost({
    required super.position,
    this.type = GhostType.red,
  }) : super(
          size: Vector2.all(Game.tileSize),
          animation: GhostSpriteSheet.getByType(type),
          speed: normalSpeed,
        ) {
    setupPathFinding(
      pathLineColor: Colors.transparent,
      factorInflateFindArea: 5,
    );
    setupVision(checkWithRaycast: true);
  }

  @override
  void update(double dt) {
    if (enabledBeheavor) {
      seePlayer(
        observed: (player) {
          if (state == GhostState.vulnerable) {
            _toScape(dt, player);
          } else {
            _pursue(dt, player);
          }
        },
        radiusVision: Game.tileSize * 2,
        notObserved: () {
          if (!isMovingAlongThePath) {
            _runRandom(dt, lastDirection);
          }
        },
      );
    }
    super.update(dt);
  }

  void _pursue(double dt, Player player) {
    Direction newDirection = _getPlayerDirection(player);
    _moveDirection(newDirection);
  }

  void _toScape(double dt, Player player) {
    Direction newDirection = _getPlayerDirection(player);

    if (newDirection.isHorizontal || newDirection.isVertical) {
      if (newDirection == Direction.left) {
        newDirection = Direction.right;
      }
      if (newDirection == Direction.right) {
        newDirection = Direction.left;
      }
      if (newDirection == Direction.up) {
        newDirection = Direction.down;
      }
      if (newDirection == Direction.down) {
        newDirection = Direction.up;
      }
      _moveDirection(newDirection);
    }
  }

  void _runRandom(double dt, Direction direction) {
    final canVerticalDirections = [
      direction,
      Direction.up,
      Direction.down,
    ];
    final canHorizontalDirections = [
      direction,
      Direction.left,
      Direction.right
    ];
    Direction newDirection = direction;
    switch (direction) {
      case Direction.left:
      case Direction.right:
        newDirection = canVerticalDirections[Random().nextInt(3)];

        break;
      case Direction.up:
      case Direction.down:
        newDirection = canHorizontalDirections[Random().nextInt(3)];
        break;
      default:
    }

    _moveDirection(newDirection);
  }

  void _moveDirection(Direction direction) {
    final ghosts = gameRef.query<Ghost>().map((e) => e.shapeHitboxes.first);

    if (canMove(direction, ignoreHitboxes: ghosts)) {
      moveFromDirection(direction);
    }
  }

  void bite() {
    state = GhostState.die;
    enabledBeheavor = false;
    final animation = GhostSpriteSheet.runEyes;
    replaceAnimation(
      SimpleDirectionAnimation(
        idleRight: animation,
        runRight: animation,
      ),
    );

    speed = dieSpeed;
    moveToPositionWithPathFinding(
      _startPositionAfterDie,
      ignoreCollisions: ignoreableCollisions,
      onFinish: _removeEyeAnimation,
    );
    Sounds.eatGhost();
    Sounds.playRetreatingBackgroundSound();
  }

  List<GameComponent> get ignoreableCollisions {
    return [
      if (gameRef.player != null) gameRef.player!,
      ...gameRef.enemies(),
    ];
  }

  @override
  void onMount() {
    _gameState = context.read();
    _gameState.listenChangePower(_pacManChangePower);
    _startInitialMovement();
    super.onMount();
  }

  void _startInitialMovement({bool withDelay = true}) async {
    switch (type) {
      case GhostType.red:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 1));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 4, Game.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.blue:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 6));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 14, Game.tileSize * 3),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.pink:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 11));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 4, Game.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
      case GhostType.orange:
        if (withDelay) {
          await Future.delayed(const Duration(seconds: 16));
        }
        moveToPositionWithPathFinding(
          Vector2(Game.tileSize * 14, Game.tileSize * 13),
          ignoreCollisions: ignoreableCollisions,
        );
        enabledBeheavor = true;
        break;
    }
  }

  void _removeEyeAnimation() {
    state = GhostState.normal;
    speed = normalSpeed;
    replaceAnimation(GhostSpriteSheet.getByType(type));
    _startInitialMovement(withDelay: false);
    if (_gameState.pacManWithPower) {
      Sounds.playPowerBackgroundSound();
    } else {
      Sounds.stopBackgroundSound();
    }
  }

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    if (other is Ghost || other is PacMan) {
      return false;
    }
    return super.onBlockMovement(intersectionPoints, other);
  }

  Future<void> _pacManChangePower(bool value) async {
    if (value) {
      state = GhostState.vulnerable;
      speed = vulnerableSpeed;
      final animation = GhostSpriteSheet.runPower;
      await replaceAnimation(
        SimpleDirectionAnimation(
          idleRight: animation,
          runRight: animation,
        ),
      );
      idle();
    } else if (state != GhostState.die) {
      state = GhostState.normal;
      speed = normalSpeed;
      replaceAnimation(
        GhostSpriteSheet.getByType(type),
      );
    }
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: size - Vector2.all(4),
        position: Vector2.all(2),
      ),
    );
    return super.onLoad();
  }

  Direction _getPlayerDirection(Player player) {
    final diffX = center.x - player.center.x;
    final diffY = center.y - player.center.y;
    if (diffX.abs() > diffY.abs()) {
      if (center.x > player.center.x) {
        return Direction.left;
      } else {
        return Direction.right;
      }
    } else {
      if (center.y > player.center.y) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    }
  }
}
