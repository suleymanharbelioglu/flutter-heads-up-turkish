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

    // Son 3 saniye sesi (timeUp ile aynı player)
    static Future<void> playLastSeconds() async {
      try {
        await _timeEndingPlayer.setAsset(AppSounds.lastseconds);
        _timeEndingPlayer.play();
      } catch (e) {
        print("Error playing lastSeconds: $e");
      }
    }

    // Süre bitti sesi (timeEndingPlayer kesilecek)
    static Future<void> playTimeUp() async {
      try {
        await _timeEndingPlayer.setAsset(AppSounds.timeUp);
        _timeEndingPlayer.play();
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
