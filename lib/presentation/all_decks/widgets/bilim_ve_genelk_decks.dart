import 'package:ben_kimim/common/helper/size/size_helper.dart';
import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/core/configs/theme/app_textstyle.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BilimVeGenelKDecks extends StatelessWidget {
  const BilimVeGenelKDecks({super.key});

  @override
  Widget build(BuildContext context) {
    // OPTİMİZASYON 1: Dış Padding sabit olduğu için const yapıldı.
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst başlık
          // OPTİMİZASYON 2: Başlık ve Padding sabit olduğu için const yapıldı.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(" BİLİM & GENEL KÜLTÜR",
                style: AppTextstyle
                    .allDecksBaslik // AppTextstyle'ın const olduğu varsayılır.
                ),
          ),
          // Liste ve veri yükleme alanı
          _DeckContentLoader(), // OPTİMİZASYON 3: BlocBuilder'ı daha temiz bir alt widget'a taşıdık.
        ],
      ),
    );
  }
}

// BlocBuilder'ı içeren ve sadece veri durumuna göre yeniden inşa edilen widget.
class _DeckContentLoader extends StatelessWidget {
  const _DeckContentLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Bu Container'ın rengi ve yüksekliği sabit olduğu için const yapıldı.
      // Not: AppColors.allDecksBackground'un statik/const olduğu varsayılır.
      color: AppColors.allDecksBackground,
      height: SizeHelper
          .categoryDeckHeight, // DeckCover boyutuna göre ayarlanabilir
      child: BlocBuilder<BilimVeGenelKDecksCubit, BilimVeGenelKDecksState>(
        builder: (context, state) {
          if (state is BilimVeGenelKDecksLoading) {
            // OPTİMİZASYON 4: Loading göstergesi const yapıldı.
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BilimVeGenelKDecksLoadFailure) {
            return Center(
              child: Text(
                state.errorMessage,
                // OPTİMİZASYON 5: TextStyle const yapıldı.
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          if (state is BilimVeGenelKDecksLoaded) {
            return _DeckListView(
                decks: state.decks); // Listeyi başka bir widget'a gönder.
          }
          // OPTİMİZASYON 6: Boş kutu const yapıldı.
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Veri yüklendikten sonra listeyi oluşturan ayrı widget.
class _DeckListView extends StatelessWidget {
  final List<DeckEntity> decks;
  const _DeckListView({required this.decks});

  @override
  Widget build(BuildContext context) {
    // Liste görünümünün kendisi de statik özelliklere sahip.
    return ListView.builder(
      // OPTİMİZASYON 7: Scroll Direction ve Padding gibi özellikler const yapıldı.
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: decks.length,
      itemBuilder: (context, index) {
        // Her bir liste öğesinin yeniden oluşturulmasını en aza indirmek için
        // itemBuilder içindeki sabitler const yapılır.
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            // SizeHelper.categoryDeckWidth'in sabit olduğu varsayılır.
            width: SizeHelper.categoryDeckWidth,
            child: DeckCover(deck: decks[index]),
          ),
        );
      },
    );
  }
}
