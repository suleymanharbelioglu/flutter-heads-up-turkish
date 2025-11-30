import 'package:flutter/material.dart';

class GameTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const GameTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds == 0 ? 0.0 : remainingSeconds / totalSeconds;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Text(
          '$remainingSeconds',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(1.5, 1.5),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
