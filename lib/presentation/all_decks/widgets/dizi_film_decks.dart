import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Dizi & Film",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<DiziFilmDecksCubit, DiziFilmDecksState>(
            builder: (context, state) {
              if (state is DiziFilmDecksLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }
              if (state is DiziFilmDecksLoaded) {
                return _decksLoaded(state.decks);
              }
              if (state is DiziFilmDecksLoadFailure) {
                return Center(
                  child: Text(
                    "Dizi & Film load failure: ${state.errorMessage}",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _decksLoaded(List<DeckEntity> deckList) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: deckList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: DeckCover(deck: deckList[index]),
          );
        },
      ),
    );
  }
}
