import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/data/card/model/card_result.dart';
import 'package:ben_kimim/presentation/bottom_nav/page/bottom_nav.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart';
import 'package:ben_kimim/presentation/phone_to_forhead/page/phone_to_forhead.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameResultPage extends StatefulWidget {
  const GameResultPage({super.key});

  @override
  State<GameResultPage> createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;
  double _scrollMax = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    setState(() {
      _scrollPosition = _scrollController.offset;
      _scrollMax = _scrollController.position.maxScrollExtent == 0
          ? 1
          : _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: BlocBuilder<ResultCubit, List<CardResultModel>>(
            builder: (context, resultList) {
              final correctCount = resultList.where((r) => r.isCorrect).length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  _buildHeader(correctCount),
                  const SizedBox(height: 8),
                  _buildScrollableResultList(resultList),
                  _buildPlayAgainButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => _navigateToHome(context),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeader(int correctCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: Text(
          "Toplam $correctCount kelime bildin!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableResultList(List<CardResultModel> resultList) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double trackHeight = constraints.maxHeight;
          final double thumbHeight =
              trackHeight * (trackHeight / (_scrollMax + trackHeight));
          final double thumbTop =
              (_scrollPosition / _scrollMax) * (trackHeight - thumbHeight);

          return Stack(
            children: [
              _buildResultListView(resultList),
              _buildScrollIndicator(thumbTop, thumbHeight),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultListView(List<CardResultModel> resultList) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        final result = resultList[index];
        return _ResultListItem(result: result);
      },
    );
  }

  Widget _buildScrollIndicator(double thumbTop, double thumbHeight) {
    return Positioned(
      right: 10,
      top: thumbTop.isNaN ? 0 : thumbTop,
      child: Container(
        width: 3,
        height: thumbHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildPlayAgainButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => _onPlayAgainPressed(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Tekrar Oyna",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPlayAgainPressed(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PhoneToForeheadPage()),
    );

    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      _resetCubits(context);
    }
  }

  void _resetCubits(BuildContext context) {
    print("reset cubits**************");
    context.read<CurrentNameCubit>().reset();
    context.read<ScoreCubit>().reset();
    context.read<ResultCubit>().reset();
  }

  void _navigateToHome(BuildContext context) {
    _resetCubits(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavPage()),
    );
  }
}

class _ResultListItem extends StatelessWidget {
  final CardResultModel result;
  const _ResultListItem({required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          result.word,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: result.isCorrect ? FontWeight.w900 : FontWeight.w600,
            color: result.isCorrect ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
