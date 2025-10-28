import 'package:ben_kimim/core/configs/assets/app_sounds.dart';
import 'package:just_audio/just_audio.dart';

class SoundHelper {
  // Ortak player sadece süre bitiyor sesleri için
  static final AudioPlayer _timeEndingPlayer = AudioPlayer();

  // Diğer sesler için ayrı player
  static final AudioPlayer _correctPlayer = AudioPlayer();
  static final AudioPlayer _passPlayer = AudioPlayer();
  static final AudioPlayer _clickPlayer = AudioPlayer();
  static final AudioPlayer _countdownPlayer = AudioPlayer();

  // Flag: son 5 saniye sesi çalıyor mu
  static bool _isPlayingLastSeconds = false;

  // Doğru cevap sesi
  static Future<void> playCorrect() async {
    try {
      await _correctPlayer.setAsset(AppSounds.correct);
      _correctPlayer.play();
    } catch (e) {
      print("Error playing correct: $e");
    }
  }

  // Pas / yanlış sesi
  static Future<void> playPass() async {
    try {
      await _passPlayer.setAsset(AppSounds.pass);
      _passPlayer.play();
    } catch (e) {
      print("Error playing pass: $e");
    }
  }

  // Buton tıklama sesi
  static Future<void> playClick() async {
    try {
      await _clickPlayer.setAsset(AppSounds.click);
      _clickPlayer.play();
    } catch (e) {
      print("Error playing click: $e");
    }
  }

  // Geri sayım sesi
  static Future<void> playCountdown() async {
    try {
      await _countdownPlayer.setAsset(AppSounds.countdown);
      _countdownPlayer.play();
    } catch (e) {
      print("Error playing countdown: $e");
    }
  }

  // Son 5 saniye sesi
  static Future<void> playLastSeconds() async {
    try {
      _isPlayingLastSeconds = true;
      await _timeEndingPlayer.setAsset(AppSounds.lastseconds);
      await _timeEndingPlayer.play();
      print(
        "play last seconds : $_isPlayingLastSeconds ................. play",
      );
    } catch (e) {
      print("Error playing lastSeconds: $e");
    }
  }

  // Pause last seconds
  static Future<void> pauseLastSeconds() async {
    try {
      if (_isPlayingLastSeconds) {
        print(
          "play last seconds : $_isPlayingLastSeconds .................  pause",
        );

        await _timeEndingPlayer.pause();
      }
    } catch (e) {
      print("Error pausing lastSeconds: $e");
    }
  }

  // Resume last seconds
  static Future<void> resumeLastSeconds() async {
    try {
      if (_isPlayingLastSeconds) {
        print(
          "play last seconds : $_isPlayingLastSeconds ................. resume",
        );

        await _timeEndingPlayer.play();
      }
    } catch (e) {
      print("Error resuming lastSeconds: $e");
    }
  }

  // Süre bitti sesi (timeEndingPlayer kesilecek)
  static Future<void> playTimeUp() async {
    try {
      await _timeEndingPlayer.setAsset(AppSounds.timeUp);
      _timeEndingPlayer.play();
      _isPlayingLastSeconds = false; // süre bitti, lastSeconds artık çalmıyor
      print("play last seconds : $_isPlayingLastSeconds .................stop");
    } catch (e) {
      print("Error playing timeUp: $e");
    }
  }

  // Tüm playerları dispose et
  static Future<void> disposeAll() async {
    await _timeEndingPlayer.dispose();
    await _correctPlayer.dispose();
    await _passPlayer.dispose();
    await _clickPlayer.dispose();
    await _countdownPlayer.dispose();
  }
}
