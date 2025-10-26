import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/home/bloc/popular_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/popular_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularDecks extends StatelessWidget {
  const PopularDecks({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<PopularDecksCubit, PopularDecksState>(
        builder: (context, state) {
          if (state is PopularDecksLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          if (state is PopularDecksLoaded) {
            return _decksLoaded(state.decks);
          }
          if (state is PopularDecksLoadFailure) {
            return Center(
              child: Text(
                "Popular laod failure ${state.errorMessage}",
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  // DeckEntity'nin DeckModel olduğunu ve import'ların yapıldığını varsayıyoruz.

  Widget _decksLoaded(List<DeckEntity> deckList) {
    // 0.6 En/Boy Oranı: Width / Height = 1 / 0.6 ≈ 1.67

    // Eğer bu widget, Column, ListView veya Container gibi
    // dikey kısıtlı bir alanda kullanılıyorsa, Expanded içine alınmalıdır.
    // Bu örnekte, dış dekorasyonları kaldırıp doğrudan GridView'i döndürüyorum.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Kenar boşlukları
      child: GridView.builder(
        // Bu GridView'i bir Column'un ana gövdesi olarak kullanıyorsanız bu önemlidir:
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // İç içe kaydırmayı engeller

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // İki sütun
          crossAxisSpacing: 10.0, // Yatay boşluk
          mainAxisSpacing: 10.0, // Dikey boşluk
          // Her bir kartın en/boy oranı (Genişlik/Yükseklik)
          childAspectRatio: 0.65,
        ),
        itemCount: deckList.length,
        itemBuilder: (context, index) {
          // Sadece DeckCover listeleniyor
          return DeckCover(deck: deckList[index]);
        },
      ),
    );
  }
}
