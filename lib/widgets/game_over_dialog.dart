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
                        fontSize: 32,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'But, would you like to win amazing prizes in our lottery?',
                      style:
                          textStyle.copyWith(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Just put your business card under our scanner',
                      style:
                          textStyle.copyWith(fontSize: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Image.asset("assets/images/scanner_info.png",
                        width: config.scanner_pic_w,
                        height: config.scanner_pic_h,
                        fit: BoxFit.fill),
                    const SizedBox(height: 20),
                    Text(
                      '...and we will sign you up automatically!',
                      style:
                          textStyle.copyWith(fontSize: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(20)),
                        overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.2),
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        gameState.reset();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        );
                      },
                      icon: Image.asset('assets/images/button_blue.png',
                          height: config.button_pic_h,
                          width: config.button_pic_w,
                          fit: BoxFit.fill),
                      label: Text(
                        'Yes!',
                        style: textStyle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(20)),
                        overlayColor: MaterialStateProperty.all(
                          Colors.black.withOpacity(0.2),
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        gameState.reset();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (route) => false,
                        );
                      },
                      icon: Image.asset('assets/images/button_red.png',
                          height: config.button_pic_h,
                          width: config.button_pic_w,
                          fit: BoxFit.fill),
                      label: Text(
                        'Maybe later!',
                        style: textStyle.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    )
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
