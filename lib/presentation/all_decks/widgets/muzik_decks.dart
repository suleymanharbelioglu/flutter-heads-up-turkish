import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuzikDecks extends StatelessWidget {
  const MuzikDecks({super.key});

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
              "Müzik",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<MuzikDecksCubit, MuzikDecksState>(
            builder: (context, state) {
              if (state is MuzikDecksLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }
              if (state is MuzikDecksLoaded) {
                return _decksLoaded(state.decks);
              }
              if (state is MuzikDecksLoadFailure) {
                return Center(
                  child: Text(
                    "Müzik load failure: ${state.errorMessage}",
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
      height: 250, // Kart yüksekliği
      child: ListView.separated(
        scrollDirection: Axis.horizontal, // Yatay kaydırma
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: deckList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160, // Kart genişliği
            child: DeckCover(deck: deckList[index]),
          );
        },
      ),
    );
  }
}
