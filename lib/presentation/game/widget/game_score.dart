import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScore extends StatelessWidget {
  const GameScore({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoreCubit, int>(
      builder: (context, score) {
        return Text(
          "$score DOĞRU", // Skor artık dinamik
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
