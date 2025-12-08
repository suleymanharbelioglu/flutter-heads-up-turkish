import 'package:ben_kimim/common/helper/size/size_helper.dart';
import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/core/configs/theme/app_textstyle.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BilimVeGenelKDecks extends StatelessWidget {
  const BilimVeGenelKDecks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(" BİLİM & GENEL KÜLTÜR",
                style: AppTextstyle.allDecksBaslik),
          ),
          _DeckContentLoader(),
        ],
      ),
    );
  }
}

class _DeckContentLoader extends StatelessWidget {
  const _DeckContentLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.allDecksBackground,
      height: SizeHelper.categoryDeckHeight,
      child: BlocBuilder<BilimVeGenelKDecksCubit, BilimVeGenelKDecksState>(
        builder: (context, state) {
          if (state is BilimVeGenelKDecksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BilimVeGenelKDecksLoadFailure) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          if (state is BilimVeGenelKDecksLoaded) {
            return _DeckListView(decks: state.decks);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DeckListView extends StatelessWidget {
  final List<DeckEntity> decks;
  const _DeckListView({required this.decks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: decks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: SizeHelper.categoryDeckWidth,
            child: DeckCover(deck: decks[index]),
          ),
        );
      },
    );
  }
}
