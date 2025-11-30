import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/popular_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/popular_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularDecks extends StatelessWidget {
  const PopularDecks({super.key});

  @override
  Widget build(BuildContext context) {
    // Statik Padding const yapıldı.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<PopularDecksCubit, PopularDecksState>(
        builder: (context, state) {
          if (state is PopularDecksLoading) {
            // Yükleme göstergesi const yapıldı ve renk güncellendi.
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }
          if (state is PopularDecksLoaded) {
            // Veri yüklendiğinde GridView'i döndür.
            return _buildDeckList(state.decks);
          }
          if (state is PopularDecksLoadFailure) {
            // Hata mesajı stili önceki widget'larla tutarlı hale getirildi.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  // Daha açıklayıcı hata mesajı.
                  "Desteler yüklenirken hata oluştu: ${state.errorMessage}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red, // Hata için kırmızı tercih edildi.
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          // Initial veya bilinmeyen durumlar için boş container const yapıldı.
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Deck listesini GridView olarak oluşturan metot.
  Widget _buildDeckList(List<DeckEntity> deckList) {
    if (deckList.isEmpty) {
      return const Center(
        child: Text(
          'Popüler deste bulunmamaktadır.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // 0.65 En/Boy Oranı (Genişlik/Yükseklik)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Kenar boşlukları
      child: GridView.builder(
        // Dikey sarmalama: Listeyi dikey alanda kısıtlamak için gereklidir.
        shrinkWrap: true,
        // Dış kaydırma widget'ları (örn. SingleChildScrollView) ile çakışmayı engeller.
        physics: const NeverScrollableScrollPhysics(),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // İki sütun
          crossAxisSpacing: 10.0, // Yatay boşluk
          mainAxisSpacing: 10.0, // Dikey boşluk
          // Her bir kartın en/boy oranı (Genişlik / Yükseklik = 0.65)
          childAspectRatio: 0.65,
        ),
        itemCount: deckList.length,
        itemBuilder: (context, index) {
          // Her bir öge için DeckCover widget'ı.
          return DeckCover(deck: deckList[index]);
        },
      ),
    );
  }
}
