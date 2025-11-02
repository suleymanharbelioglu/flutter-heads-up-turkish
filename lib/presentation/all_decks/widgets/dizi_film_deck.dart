import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiziFilmDecks extends StatelessWidget {
  const DiziFilmDecks({super.key});

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
            child: Text(
              "Dizi/Film",
              style: TextStyle(fontSize: 32, color: AppColors.primary),
            ),
          ),
          Container(
            color: Colors.amber.shade100,
            height: 220, // DeckCover boyutuna göre ayarlanabilir
            child: BlocBuilder<DiziFilmDecksCubit, DiziFilmDecksState>(
              builder: (context, state) {
                if (state is DiziFilmDecksLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DiziFilmDecksLoadFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }
                if (state is DiziFilmDecksLoaded) {
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
            width: 150, // Burayı sabit veriyoruz
            child: DeckCover(deck: deckList[index]),
          ),
        );
      },
    );
  }
}
