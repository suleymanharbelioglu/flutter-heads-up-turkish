// game_page.dart
import 'dart:async';
import 'package:ben_kimim/presentation/game_result/page/game_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart';
import 'package:ben_kimim/presentation/game/widget/game_score.dart';
import 'package:ben_kimim/presentation/game/widget/game_timer.dart';
import 'package:ben_kimim/presentation/home/pages/home.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _oldOffsetAnimation;
  late Animation<Offset> _newOffsetAnimation;

  String? _oldName;
  String? _newName;
  Color? _oldCardColor;
  String? _oldCardText;

  bool _isAnimating = false;
  bool _isTimeOver = false;

  Timer? _timer;
  int? _remainingSeconds; // Local variable, Cubit değişmeyecek

  @override
  void initState() {
    super.initState();
    _setupOrientation();
    _setupAnimations();
    _loadInitialName();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _resetOrientation();
    super.dispose();
  }

  /// Landscape mod ayarları
  void _setupOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Kart animasyonlarını ayarla
  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _oldOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _newOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  /// İlk kartı yükle ve timer başlat
  void _loadInitialName() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CurrentNameCubit>();
      cubit.generateNewName();
      setState(() {
        _oldName = cubit.state;
      });
      _startTimer();
    });
  }

  /// Timer başlat (local variable üzerinden)
  void _startTimer() {
    final timerCubit = context.read<TimerCubit>();
    _remainingSeconds = timerCubit.state; // Başlangıç süresi

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds != null && _remainingSeconds! > 0) {
        setState(() => _remainingSeconds = _remainingSeconds! - 1);
      } else {
        t.cancel();
        _onTimeOver();
      }
    });
  }

  /// Süre bittiğinde overlay göster ve 1 sn sonra GameResultPage
  void _onTimeOver() {
    setState(() {
      _isTimeOver = true;
      _isAnimating = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameResultPage()),
      );
    });
  }

  /// Doğru / yanlış cevabı işle
  void _onAnswer(bool isCorrect) async {
    if (_isAnimating || _isTimeOver) return;

    final currentCubit = context.read<CurrentNameCubit>();
    final scoreCubit = context.read<ScoreCubit>();

    if (isCorrect) scoreCubit.increment();

    currentCubit.generateNewName();
    final nextName = currentCubit.state;

    setState(() {
      _oldCardColor = isCorrect ? Colors.green : Colors.red;
      _oldCardText = isCorrect ? "Doğru" : "Pass";
      _newName = nextName;
      _isAnimating = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Stack(
          children: [
            _buildAnimatedNames(),
            _buildActionButtons(),
            _buildExitButton(),
            _buildScore(),
            _buildTimer(),
            if (_isTimeOver) _buildTimeOverOverlay(),
          ],
        ),
      ),
    );
  }

  /// Kart animasyonları
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

  /// Kart widget
  Widget _buildCard({required String text, required Color color}) {
    return SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        color: color,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Doğru / Yanlış butonları
  Widget _buildActionButtons() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Row(
        children: [
          _buildAnswerButton(
            "Doğru",
            Colors.greenAccent,
            () => _onAnswer(true),
          ),
          const SizedBox(width: 16),
          _buildAnswerButton(
            "Yanlış",
            Colors.redAccent,
            () => _onAnswer(false),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: (_isAnimating || _isTimeOver) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color == Colors.greenAccent ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  /// Exit butonu
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

  void _onExitPressed() {
    context.read<CurrentNameCubit>().reset();
    context.read<ScoreCubit>().reset();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  /// Skor widget
  Widget _buildScore() {
    return Align(alignment: Alignment.bottomCenter, child: GameScore());
  }

  /// Timer widget
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

  /// Süre bitti overlay
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
}
