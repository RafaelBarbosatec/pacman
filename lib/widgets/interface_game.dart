import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:avnetman/util/util_spritesheet.dart';

class InterfaceGame extends StatefulWidget {
  const InterfaceGame({Key? key}) : super(key: key);

  @override
  State<InterfaceGame> createState() => _InterfaceGameState();
}

class _InterfaceGameState extends State<InterfaceGame> {
  late GameState _state;
  final double sizeIcon = 20;

  @override
  void initState() {
    _state = BonfireInjector.instance.get();
    _state.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _state.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    );
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(178, 0x81, 0xc7, 0x84),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _state.score.toString(),
              style: textStyle,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Wrap(
              spacing: MediaQuery.of(context).size.width * 0.02,
              children: List.generate(_state.lifes, (i) {
                return SizedBox(
                  width: MediaQuery.of(context).size.height * 0.03,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: UtilSpriteSheet.dotPower.asWidget(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _listener() {
    setState(() {});
  }
}
