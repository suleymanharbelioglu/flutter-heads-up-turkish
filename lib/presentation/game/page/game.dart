// game_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game/widget/game_score.dart';
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
  bool _isAnimating = false;

  Color? _oldCardColor;
  String? _oldCardText;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CurrentNameCubit>();
      cubit.generateNewName();
      setState(() {
        _oldName = cubit.state; // İlk kartı göster
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onAnswer(bool isCorrect) async {
    if (_isAnimating) return;

    final currentCubit = context.read<CurrentNameCubit>();
    final scoreCubit = context.read<ScoreCubit>();

    if (isCorrect) scoreCubit.increment();

    // Yeni isim üret ve _newName olarak ata
    currentCubit.generateNewName();
    final nextName = currentCubit.state;

    setState(() {
      _oldCardColor = isCorrect ? Colors.green : Colors.red;
      _oldCardText = isCorrect ? "Doğru" : "Pass";
      _newName = nextName; // animasyon için yeni kart
      _isAnimating = true;
    });

    await _controller.forward();

    // Animasyon bitti, kartları resetle ve eski kartı yeni isim yap
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
            Align(alignment: Alignment.bottomCenter, child: GameScore()),
          ],
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

  Widget _buildActionButtons() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _isAnimating ? null : () => _onAnswer(true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Doğru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _isAnimating ? null : () => _onAnswer(false),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Yanlış',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: ElevatedButton(
        onPressed: () {
          context.read<CurrentNameCubit>().reset();
          context.read<ScoreCubit>().reset();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        },
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
}
