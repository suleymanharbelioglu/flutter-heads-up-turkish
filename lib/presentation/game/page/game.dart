import 'dart:async';
import 'package:ben_kimim/common/helper/sound/sound.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/presentation/bottom_nav/page/bottom_nav.dart';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart';
import 'package:ben_kimim/presentation/game_result/page/game_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart';
import 'package:ben_kimim/presentation/game/widget/game_score.dart';
import 'package:ben_kimim/presentation/game/widget/game_timer.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  int? _remainingSeconds;

  StreamSubscription<AccelerometerEvent>? _sensorSub;
  String _currentZone = "play";
  Timer? _timer;
  bool _isPaused = false;

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

  void _setupOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

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

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isPaused) return;
      if (_remainingSeconds != null && _remainingSeconds! > 0) {
        setState(() => _remainingSeconds = _remainingSeconds! - 1);

        if (_remainingSeconds == 5) {
          SoundHelper.playLastSeconds();
        }
      } else {
        t.cancel();
        _onTimeOver();
      }
    });
  }

  void _onTimeOver() async {
    final resultCubit = context.read<ResultCubit>();

    if (_oldName != null &&
        (_oldCardText == null || _oldCardText == _oldName)) {
      resultCubit.addPassWord(_oldName!);
    }
    setState(() {
      _isTimeOver = true;
      _isAnimating = true;
    });

    await SoundHelper.playTimeUp();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameResultPage()),
      );
    });
  }

  void _startSensorListening() {
    _sensorSub = accelerometerEvents.listen((event) {
      if (_isAnimating || _isTimeOver || _isPaused) return;

      final zone = _detectZone(
        event.x,
        event.y,
        event.z,
      );
      if (zone != null && zone != _currentZone) {
        _handleZoneTransition(
          from: _currentZone,
          to: zone,
        );
      }
    });
  }

  String? _detectZone(double x, double y, double z) {
    bool inRange(double value, double a, double b) {
      final min = a < b ? a : b;
      final max = a < b ? b : a;
      return value >= min && value <= max;
    }

    if (inRange(x, 8, 10) && inRange(y, -4, 4) && inRange(z, -6, 6)) {
      return "play";
    }

    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, 7, 10)) {
      return "pass";
    }

    if (inRange(x, -4, 7) && inRange(y, -4, 4) && inRange(z, -10, -7)) {
      return "correct";
    }
    return null;
  }

  void _handleZoneTransition({required String from, required String to}) {
    if (_isAnimating || _isTimeOver || _isPaused) return;

    if (from == "play" && (to == "pass" || to == "correct")) {
      setState(() {
        _currentZone = to;
        _oldCardColor = to == "pass" ? AppColors.pass : AppColors.correct;
        _oldCardText = to == "pass" ? "PASS" : "DOĞRU";
      });

      if (to == "pass") {
        SoundHelper.playPass();
      } else {
        SoundHelper.playCorrect();
      }

      return;
    }

    if ((from == "pass" || from == "correct") && to == "play") {
      _handleReturnToPlay(fromZone: from);
      return;
    }
  }

  Future<void> _handleReturnToPlay({required String fromZone}) async {
    if (_isAnimating || _isTimeOver || _isPaused) return;

    final currentNameCubit = context.read<CurrentNameCubit>();
    final scoreCubit = context.read<ScoreCubit>();
    final resultCubit = context.read<ResultCubit>();

    if (fromZone == "correct") {
      scoreCubit.increment();
      resultCubit.addCorrectWord(currentNameCubit.state);
    } else if (fromZone == "pass") {
      resultCubit.addPassWord(currentNameCubit.state);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _buildAnimatedNames(),
              _buildBackButton(),
              _buildScore(),
              _buildTimer(),
              if (_isTimeOver) _buildTimeOverOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNames() {
    return Stack(
      children: [
        if (_oldName != null)
          SlideTransition(
            position: _oldOffsetAnimation,
            child: _buildCard(
              text: _oldCardText ?? _oldName!,
              color: _oldCardColor ?? AppColors.game,
            ),
          ),
        if (_newName != null)
          SlideTransition(
            position: _newOffsetAnimation,
            child: _buildCard(text: _newName!, color: AppColors.game),
          ),
      ],
    );
  }

  Widget _buildCard({required String text, required Color color}) {
    return SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        color: color,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 20,
      left: 20,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
        onPressed: _onBackPressed,
      ),
    );
  }

  void _onBackPressed() {
    print("on back pressed ..............");
    setState(() => _isPaused = true);
    _showPauseDialog();
    SoundHelper.pauseLastSeconds();
  }

  Future<void> _showPauseDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 320,
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5058E2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      "DURAKLATILDI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Çıkmak istediğine emin misin?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4F81),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<CurrentNameCubit>().reset();
                            context.read<ScoreCubit>().reset();
                            context.read<ResultCubit>().reset();

                            _timer?.cancel();
                            _sensorSub?.cancel();

                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BottomNavPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Ana Menü",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CD964),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() => _isPaused = false);
                            SoundHelper.resumeLastSeconds();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Devam Et",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScore() {
    return Align(alignment: Alignment.bottomCenter, child: GameScore());
  }

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

  Widget _buildTimeOverOverlay() {
    return Container(
      color: AppColors.timeUp,
      alignment: Alignment.center,
      child: const Text(
        "Süre Bitti!",
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
