
>>>>>>> 0936495 (deck cover , deckflip)
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/home/bloc/c1_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/c1_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C1Decks extends StatelessWidget {
  const C1Decks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C1DecksCubit, C1DecksState>(
      builder: (context, state) {
        if (state is C1DecksLoading) {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        }
        if (state is C1DecksLoaded) {
          return _decksLoaded(state.decks);
        }
        if (state is C1DecksLoadFailure) {
          return Center(
            child: Text(
              "c1 laod failure ${state.errorMessage}",
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
          );
        }
        return Container();
      },
    );
  }

  Container _decksLoaded(List<DeckEntity> deckList) {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade100),
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Text("c1 decks"),
          SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.amber),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return DeckCover(deck: deckList[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 10);
              },
              itemCount: deckList.length,
            ),
          ),
        ],
      ),
    );
  }
}
