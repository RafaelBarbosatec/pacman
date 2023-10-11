import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pacman/decoration/dot.dart';
import 'package:pacman/decoration/dot_power.dart';
import 'package:pacman/decoration/sensor_gate.dart';
import 'package:pacman/enemy/ghost.dart';
import 'package:pacman/menu.dart';
import 'package:pacman/player/pacman.dart';
import 'package:pacman/util/sounds.dart';
import 'package:pacman/widgets/interface_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Sounds.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MenuPage(),
        '/game': (_) => const Game(),
      },
    );
  }
}

class Game extends StatelessWidget {
  static const double tileSize = 48.0;
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: BonfireWidget(
          map: WorldMapByTiled(
            'map.tmj',
            objectsBuilder: {
              'sensor_left': (properties) => SensorGate(
                    position: properties.position,
                    direction: DiractionGate.left,
                  ),
              'sensor_right': (properties) => SensorGate(
                    position: properties.position,
                    direction: DiractionGate.right,
                  ),
              'dot': (properties) => Dot(
                    position: properties.position,
                  ),
              'dot_power': (properties) => DotPower(
                    position: properties.position,
                  ),
              'ghost_red': (properties) => Ghost(
                    position: properties.position,
                    type: GhostType.red,
                  ),
              'ghost_pink': (properties) => Ghost(
                    position: properties.position,
                    type: GhostType.pink,
                  ),
              'ghost_orange': (properties) => Ghost(
                    position: properties.position,
                    type: GhostType.orange,
                  ),
              'ghost_blue': (properties) => Ghost(
                    position: properties.position,
                    type: GhostType.blue,
                  ),
            },
          ),
          joystick: Joystick(
            keyboardConfig: KeyboardConfig(),
          ),
          overlayBuilderMap: {
            'score': ((context, game) => const InterfaceGame()),
          },
          initialActiveOverlays: const ['score'],
          cameraConfig: CameraConfig(
            moveOnlyMapArea: true,
            initialMapZoomFit: InitialMapZoomFitEnum.fitHeight,
          ),
          player: PacMan(
            position: PacMan.initialPosition,
          ),
        ),
      ),
    );
  }
}
