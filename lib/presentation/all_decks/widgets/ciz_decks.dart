import 'package:ben_kimim/common/helper/size/size_helper.dart';
import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/core/configs/theme/app_textstyle.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/ciz_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/ciz_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CizDecks extends StatelessWidget {
  const CizDecks({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text("CİZ", style: AppTextstyle.allDecksBaslik),
          ),
          Container(
            color: AppColors.allDecksBackground,
            height: SizeHelper
                .categoryDeckHeight, // DeckCover boyutuna göre ayarlanabilir
            child: BlocBuilder<CizDecksCubit, CizDecksState>(
              builder: (context, state) {
                if (state is CizDecksLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CizDecksLoadFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }
                if (state is CizDecksLoaded) {
                  return _decksLoaded(state.decks);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _decksLoaded(List<DeckEntity> deckList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: deckList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: SizeHelper.categoryDeckWidth, // Burayı sabit veriyoruz
            child: DeckCover(deck: deckList[index]),
          ),
        );
      },
    );
  }
}
