import 'package:ben_kimim/common/helper/size/size_helper.dart';
import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/core/configs/theme/app_textstyle.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/yemeker_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/yemekler_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Yemekler kategorisindeki desteleri yatay olarak listeleyen optimize edilmiş widget.
class YemeklerDecks extends StatelessWidget {
  const YemeklerDecks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori Başlığı
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            // 'AppTextstyle.allDecksBaslik' tipinin const olduğundan emin olunmalıdır.
            child: Text("Yemekler", style: AppTextstyle.allDecksBaslik),
          ),
          // Deck Yükleyici ve Gösterim Alanı (BlocBuilder'ı içerir)
          _DeckContent(),
        ],
      ),
    );
  }
}

// BlocBuilder'ı içeren ve sadece state değiştiğinde yeniden oluşturulan özel widget.
class _DeckContent extends StatelessWidget {
  const _DeckContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.allDecksBackground,
      height: SizeHelper.categoryDeckHeight,
      child: BlocBuilder<YemeklerDecksCubit, YemeklerDecksState>(
        builder: (context, state) {
          if (state is YemeklerDecksLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is YemeklerDecksLoadFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  // Hata mesajı daha açıklayıcı hale getirildi.
                  'Hata: Desteler yüklenemedi. ${state.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }
          if (state is YemeklerDecksLoaded) {
            return _buildDeckList(state.decks);
          }
          // Initial durumu veya bilinmeyen durumlar için boş bir alan.
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Destelerin yatay olarak listelendiği veya boş liste uyarısı verildiği metot.
  Widget _buildDeckList(List<DeckEntity> deckList) {
    // Liste boşsa kullanıcıya bilgi verilir.
    if (deckList.isEmpty) {
      return const Center(
        child: Text(
          'Bu kategoride henüz bir deste bulunmamaktadır.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: deckList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: SizeHelper.categoryDeckWidth,
            child: DeckCover(deck: deckList[index]),
          ),
        );
      },
    );
  }
}
