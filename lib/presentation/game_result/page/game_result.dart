import 'package:ben_kimim/data/card/model/card_result.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart';
import 'package:ben_kimim/presentation/home/pages/home.dart';
import 'package:ben_kimim/presentation/phone_to_forhead/page/phone_to_forhead.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameResultPage extends StatelessWidget {
  const GameResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          title: const Text("Sonuçlar"),
          backgroundColor: Colors.blueGrey.shade700,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ResultCubit, List<CardResultModel>>(
          builder: (context, resultList) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCorrectCount(resultList),
                  const Divider(color: Colors.white54, thickness: 1),
                  _buildResultList(resultList),
                  _buildButtons(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCorrectCount(List<CardResultModel> resultList) {
    final correctCount = resultList.where((result) => result.isCorrect).length;

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        '$correctCount doğru bildiniz',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildResultList(List<CardResultModel> resultList) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: resultList.map((result) => _buildResultCard(result)).toList(),
      ),
    );
  }

  Widget _buildResultCard(CardResultModel result) {
    return Card(
      color: result.isCorrect
          ? Colors.greenAccent
          : Colors.redAccent.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          result.word,
          style: TextStyle(
            fontSize: 24,
            fontWeight: result.isCorrect ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _navigateToHome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade700,
              ),
              child: const Text(
                "Ana Sayfa",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                _resetCubits(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PhoneToForeheadPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
              ),
              child: const Text(
                "Tekrar Oyna",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetCubits(BuildContext context) {
    context.read<CurrentNameCubit>().reset();
    context.read<ScoreCubit>().reset();
    context.read<ResultCubit>().reset();
  }

  void _navigateToHome(BuildContext context) {
    _resetCubits(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}
