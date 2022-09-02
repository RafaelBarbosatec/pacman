import 'package:flame_audio/flame_audio.dart';

class Sounds {
  static Future initialize() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'munch_1.wav',
      'munch_2.wav',
      'power_pellet.wav',
      'eat_ghost.wav',
      'retreating.wav',
      'death.wav',
    ]);
  }

  static String _currentBackground = '';

  static void munch({bool first = true}) {
    FlameAudio.play(first ? 'munch_1.wav' : 'munch_2.wav');
  }

  static void eatGhost() {
    FlameAudio.play('eat_ghost.wav');
  }

  static void death() {
    FlameAudio.play('death.wav');
  }

  static stopBackgroundSound() {
    _currentBackground = '';
    return FlameAudio.bgm.stop();
  }

  static void playPowerBackgroundSound() async {
    String name = 'power_pellet.wav';
    if (_currentBackground == name) {
      return;
    }
    await FlameAudio.bgm.stop();
    _currentBackground = name;
    FlameAudio.bgm.play(name);
  }

  static void playRetreatingBackgroundSound() async {
    String name = 'retreating.wav';
    if (_currentBackground == name) {
      return;
    }
    await FlameAudio.bgm.stop();
    _currentBackground = name;
    FlameAudio.bgm.play(name);
  }

  static void pauseBackgroundSound() {
    FlameAudio.bgm.pause();
  }

  static void resumeBackgroundSound() {
    FlameAudio.bgm.resume();
  }

  static void dispose() {
    FlameAudio.bgm.dispose();
  }
}
