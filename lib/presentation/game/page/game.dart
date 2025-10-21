// game_page.dart
import 'dart:async';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart';
import 'package:ben_kimim/presentation/game_result/page/game_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart';
import 'package:ben_kimim/presentation/game/widget/game_score.dart';
import 'package:ben_kimim/presentation/game/widget/game_timer.dart';
import 'package:ben_kimim/presentation/home/pages/home.dart';

/// GamePage: Sensör kontrollü oyun ekranı
/// - Kartlar sensörle Play / Pass / Correct olarak kontrol edilir
/// - Animasyon ve skor işlemleri burada gerçekleşir
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  // -----------------------
  // ANIMASYON NESNELERİ
  // -----------------------
  late AnimationController _controller;
  late Animation<Offset> _oldOffsetAnimation;
  late Animation<Offset> _newOffsetAnimation;

  // -----------------------
  // KART İSİMLERİ VE RENK
  // -----------------------
  String? _oldName;
  String? _newName;
  Color? _oldCardColor;
  String? _oldCardText;

  // -----------------------
  // DURUM KONTROL FLAGLERİ
  // -----------------------
  bool _isAnimating = false;
  bool _isTimeOver = false;
  int? _remainingSeconds;

  // -----------------------
  // SENSÖR ABONELİĞİ
  // -----------------------
  StreamSubscription<AccelerometerEvent>? _sensorSub;
  String _currentZone = "play";

  // -----------------------
  // TIMER
  // -----------------------
  Timer? _timer;

  // -----------------------
  // DEBUG SENSÖR DEĞERLERİ
  // -----------------------
  double _debugX = 0, _debugY = 0, _debugZ = 0;

  // -----------------------
  // INIT / DISPOSE
  // -----------------------
  @override
  void initState() {
    super.initState();
    _setupOrientation();
    _setupAnimations();
    _loadInitialNameAndStartTimer();
    _startSensorListening();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _sensorSub?.cancel();
    _resetOrientation();
    super.dispose();
  }

  // -----------------------
  // ORIENTATION SETUP
  // -----------------------
  void _setupOrientation() {
    // Yatay moda zorla ve status/navigation bar gizle
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _resetOrientation() {
    // Sayfadan çıkınca dikey moda dön ve system barları geri getir
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // -----------------------
  // ANIMASYONLAR
  // -----------------------
  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Eski kart yukarı kayacak
    _oldOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Yeni kart alttan gelecek
    _newOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // -----------------------
  // İLK İSİM VE TIMER
  // -----------------------
  void _loadInitialNameAndStartTimer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nameCubit = context.read<CurrentNameCubit>();
      nameCubit.generateNewName();
      setState(() => _oldName = nameCubit.state);
      _startTimer();
    });
  }

  void _startTimer() {
    final timerCubit = context.read<TimerCubit>();
    _remainingSeconds = timerCubit.state;

    // 1 saniyelik periyodik timer
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds != null && _remainingSeconds! > 0) {
        setState(() => _remainingSeconds = _remainingSeconds! - 1);
      } else {
        t.cancel();
        _onTimeOver();
      }
    });
  }

  void _onTimeOver() {
    setState(() {
      _isTimeOver = true;
      _isAnimating = true;
    });

    // 1 saniye bekle ve sonuç sayfasına geç
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameResultPage()),
      );
    });
  }

  // -----------------------
  // SENSÖR DİNLEME
  // -----------------------
  void _startSensorListening() {
    _sensorSub = accelerometerEvents.listen((event) {
      // Debug için değerleri güncelle
      setState(() {
        _debugX = event.x;
        _debugY = event.y;
        _debugZ = event.z;
      });

      // Animasyon veya süre dolmuşsa işlem yok
      if (_isAnimating || _isTimeOver) return;

      final zone = _detectZone(event.x, event.y, event.z);

      // Aralık dışı null ise işlem yapma
      if (zone != null && zone != _currentZone) {
        _handleZoneTransition(from: _currentZone, to: zone);
      }
    });
  }

  // -----------------------
  // ZONE DETECTION
  // -----------------------
  String? _detectZone(double x, double y, double z) {
    bool inRange(double value, double a, double b) {
      final min = a < b ? a : b;
      final max = a < b ? b : a;
      return value >= min && value <= max;
    }

    // PLAY: x 8-10, y -4-4, z -6-6
    if (inRange(x, 8, 10) && inRange(y, -4, 4) && inRange(z, -6, 6)) {
      return "play";
    }

    // PASS: x -4-7, y -4-4, z 7-10
    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, 7, 10)) {
      return "pass";
    }

    // CORRECT: x -4-7, y -4-4, z -10…-7
    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, -10, -7)) {
      return "correct";
    }

    return null; // Aralık dışında
  }

  // -----------------------
  // ZONE GEÇİŞ İŞLEMİ
  // -----------------------
  void _handleZoneTransition({required String from, required String to}) {
    if (_isAnimating || _isTimeOver) return;

    // PLAY -> PASS / CORRECT
    if (from == "play" && (to == "pass" || to == "correct")) {
      setState(() {
        _currentZone = to;
        _oldCardColor = to == "pass" ? Colors.red : Colors.green;
        _oldCardText = to == "pass" ? "PASS" : "DOĞRU";
      });
      return;
    }

    // PASS / CORRECT -> PLAY
    if ((from == "pass" || from == "correct") && to == "play") {
      _handleReturnToPlay(fromZone: from);
      return;
    }
  }

  // -----------------------
  // KART GEÇİŞ ANİMASYONU VE SKOR
  // -----------------------
  Future<void> _handleReturnToPlay({required String fromZone}) async {
    if (_isAnimating || _isTimeOver) return;

    final currentNameCubit = context.read<CurrentNameCubit>();
    final scoreCubit = context.read<ScoreCubit>();
    final resultCubit = context.read<ResultCubit>();

    if (fromZone == "correct") {
      scoreCubit.increment();
      resultCubit.addCorrectWord(currentNameCubit.state); // Cubit’e ekle
    } else if (fromZone == "pass") {
      resultCubit.addPassWord(currentNameCubit.state); // Cubit’e ekle
    }

    currentNameCubit.generateNewName();
    final nextName = currentNameCubit.state;

    setState(() {
      _isAnimating = true;
      _newName = nextName;
      _currentZone = "play";
    });

    await _controller.forward();

    setState(() {
      _oldName = nextName;
      _oldCardColor = null;
      _oldCardText = null;
      _newName = null;
      _isAnimating = false;
    });

    _controller.reset();
  }

  // -----------------------
  // BUILD
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Stack(
          children: [
            _buildAnimatedNames(), // Kart animasyonları
            _buildExitButton(), // Çıkış butonu
            _buildScore(), // Skor widget
            _buildTimer(), // Timer widget
            if (_isTimeOver) _buildTimeOverOverlay(), // Süre bitince overlay
            _buildSensorDebug(), // Debug sensör değerleri
          ],
        ),
      ),
    );
  }

  // -----------------------
  // WIDGET: KART ANİMASYONU
  // -----------------------
  Widget _buildAnimatedNames() {
    return Stack(
      children: [
        if (_oldName != null)
          SlideTransition(
            position: _oldOffsetAnimation,
            child: _buildCard(
              text: _oldCardText ?? _oldName!,
              color: _oldCardColor ?? Colors.greenAccent,
            ),
          ),
        if (_newName != null)
          SlideTransition(
            position: _newOffsetAnimation,
            child: _buildCard(text: _newName!, color: Colors.greenAccent),
          ),
      ],
    );
  }

  // -----------------------
  // WIDGET: TEK KART
  // -----------------------
  Widget _buildCard({required String text, required Color color}) {
    return SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        color: color,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // -----------------------
  // WIDGET: ÇIKIŞ BUTONU
  // -----------------------
  Widget _buildExitButton() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: ElevatedButton(
        onPressed: _onExitPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Exit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // -----------------------
  // ÇIKIŞ BUTONU İŞLEMİ
  // -----------------------
  void _onExitPressed() {
    context.read<CurrentNameCubit>().reset();
    context.read<ScoreCubit>().reset();
    _sensorSub?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  // -----------------------
  // WIDGET: SKOR
  // -----------------------
  Widget _buildScore() {
    return Align(alignment: Alignment.bottomCenter, child: GameScore());
  }

  // -----------------------
  // WIDGET: TIMER
  // -----------------------
  Widget _buildTimer() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GameTimer(
          remainingSeconds:
              _remainingSeconds ?? context.read<TimerCubit>().state,
          totalSeconds: context.read<TimerCubit>().state,
        ),
      ),
    );
  }

  // -----------------------
  // WIDGET: SÜRE BİTTİ OVERLAY
  // -----------------------
  Widget _buildTimeOverOverlay() {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      child: const Text(
        "Süre Bitti",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  // -----------------------
  // WIDGET: SENSÖR DEBUG PANEL
  // -----------------------
  Widget _buildSensorDebug() {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.5),
        child: Text(
          'x: ${_debugX.toStringAsFixed(2)}\n'
          'y: ${_debugY.toStringAsFixed(2)}\n'
          'z: ${_debugZ.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
