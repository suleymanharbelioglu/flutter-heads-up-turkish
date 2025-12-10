import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          width: 70.h,
          height: 70.h,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 6.h,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Text(
          '$remainingSeconds',
          style: TextStyle(
            fontSize: 11.sp,
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
