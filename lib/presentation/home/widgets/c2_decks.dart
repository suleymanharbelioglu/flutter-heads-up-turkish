
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/home/bloc/c2_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/c2_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C2Decks extends StatelessWidget {
  const C2Decks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C2DecksCubit, C2DecksState>(
      builder: (context, state) {
        if (state is C2DecksLoading) {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        }
        if (state is C2DecksLoaded) {
          return _decksLoaded(state.decks);
        }
        if (state is C2DecksLoadFailure) {
          return Center(
            child: Text(
              "c2 laod failure ${state.errorMessage}",
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

      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Text("c2 decks"),
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
                return SizedBox(width: 20);
              },
              itemCount: deckList.length,
            ),
          ),
        ],
      ),
    );
  }
}
