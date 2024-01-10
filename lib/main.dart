import 'dart:convert';
import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:avnetman/decoration/dot.dart';
import 'package:avnetman/decoration/dot_power.dart';
import 'package:avnetman/decoration/sensor_gate.dart';
import 'package:avnetman/enemy/ghost.dart';
import 'package:avnetman/menu.dart';
import 'package:avnetman/player/pacman.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:avnetman/util/mqtt.dart';
import 'package:avnetman/util/sounds.dart';
import 'package:avnetman/widgets/interface_game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BonfireInjector.instance.put((i) => GameState());
  Sounds.initialize();

  startServices();

  runApp(const MyApp());
}

void startServices() {
  // mqtt doesn't work in web profile
  if (!kIsWeb) {
    mqttService.start();
  }
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

class AppConfig {
  double height = -1;
  double width = -1;
  double zoom = 1.0;

  void read(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    const double heightMap = 1004.0;

    height = sizeScreen.height;
    width = sizeScreen.width;
    zoom = height / heightMap;

    List<String> items = [
      "/apps/pacman/config.json",
      "/usr/share/pacman/config.json",
      "config.json"
    ];
    for (var item in items) {
      try {
        final File file = File(item);
        final response = file.readAsStringSync();
        final config = jsonDecode(response);

        height = config["height"] ?? sizeScreen.height;
        width = config["width"] ?? sizeScreen.width;
        zoom = config["zoom"] ?? width / heightMap;
        return;
      } catch (e) {
        continue;
      }
    }
  }
}

class Game extends StatelessWidget {
  static const double tileSize = 48.0;
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfig();
    config.read(context);
    double zoom = config.zoom;
    PacMan player = PacMan(position: PacMan.initialPosition);
    WorldMapByTiled map = WorldMapByTiled(
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
    );
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          width: config.width,
          height: config.height,
          child: BonfireWidget(
            backgroundColor: Colors.white,
            map: map,
            joystick: Joystick(
              keyboardConfig: KeyboardConfig(),
            ),
            overlayBuilderMap: {
              'score': ((context, game) => const InterfaceGame()),
            },
            initialActiveOverlays: const ['score'],
            cameraConfig: CameraConfig(
              smoothCameraEnabled: true,
              zoom: zoom,
              target: map,
            ),
            player: player,
          ),
        ),
      ),
    );
  }
}
