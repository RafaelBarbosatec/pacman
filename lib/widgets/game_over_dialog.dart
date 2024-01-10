import 'package:bonfire/state_manager/bonfire_injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avnetman/main.dart';
import 'package:avnetman/util/game_state.dart';
import 'package:avnetman/util/mqtt.dart';

class EnterButtonIntent extends Intent {}

class EscapeButtonIntent extends Intent {}

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({Key? key}) : super(key: key);

  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const GameOverDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = BonfireInjector.instance.get();
    AppConfig config = AppConfig();
    config.read(context);
    TextStyle textStyle = const TextStyle(color: Colors.black);
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): EnterButtonIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): EscapeButtonIntent(),
      },
      child: Actions(
        actions: {
          EnterButtonIntent: CallbackAction(onInvoke: (i) {
            gameState.reset();
            if (!kIsWeb) mqttService.publishLottery();
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
            return null;
          }),
          EscapeButtonIntent: CallbackAction(onInvoke: (i) {
            gameState.reset();
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
            return null;
          }),
        },
        child: Focus(
          autofocus: true,
          child: Center(
            heightFactor: 0.7,
            widthFactor: 0.7,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Game Over - Better luck next time',
                      style: textStyle.copyWith(
                        fontSize: 40,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'But, would you like to win amazing prizes in our lottery?',
                      style:
                          textStyle.copyWith(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Just put your business card under our scanner',
                      style:
                          textStyle.copyWith(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Image.asset("assets/images/scanner_info.png",
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fill),
                    const SizedBox(height: 20),
                    Text(
                      '...and we will sign you up automatically!',
                      style:
                          textStyle.copyWith(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                              overlayColor: MaterialStateProperty.all(
                                Colors.black.withOpacity(0.4),
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.transparent),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.transparent),
                            ),
                            onPressed: () {
                              gameState.reset();
                              // TODO mqtt message
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                              );
                            },
                            icon: Image.asset('assets/images/button_blue.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                fit: BoxFit.fill),
                            label: Text(
                              'Yes!',
                              style: textStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height *
                                          0.05),
                            ),
                          ),
                          const SizedBox(width: 50),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                              overlayColor: MaterialStateProperty.all(
                                Colors.black.withOpacity(0.2),
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(color: Colors.transparent),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.transparent),
                            ),
                            onPressed: () {
                              gameState.reset();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                              );
                            },
                            icon: Image.asset('assets/images/button_red.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                fit: BoxFit.fill),
                            label: Text('Maybe later!',
                                style: textStyle.copyWith(
                                    color: Colors.red,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.05)),
                          ),
                        ]
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
