
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/home/bloc/c3_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/c3_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C3Decks extends StatelessWidget {
  const C3Decks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C3DecksCubit, C3DecksState>(
      builder: (context, state) {
        if (state is C3DecksLoading) {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        }
        if (state is C3DecksLoaded) {
          return _decksLoaded(state.decks);
        }
        if (state is C3DecksLoadFailure) {
          return Center(
            child: Text(
              "c3 laod failure ${state.errorMessage}",
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

>>>>>>> 0936495 (deck cover , deckflip)
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Text("c3 decks"),
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
                return SizedBox(width: 30);
              },
              itemCount: deckList.length,
            ),
          ),
        ],
      ),
    );
  }
}
