import 'package:ben_kimim/common/helper/size/size_helper.dart';
import 'package:ben_kimim/common/widget/deck/deck_cover.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/core/configs/theme/app_textstyle.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/cizgifilm_anime_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/cizgifilm_anime_decks_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CizgiFilmAnimeDecks extends StatelessWidget {
 const CizgiFilmAnimeDecks({super.key});

 @override
 Widget build(BuildContext context) {
  // OPTİMİZASYON 1: Tüm üst düzey statik widget'lar const yapıldı.
  return const Padding(
   padding: EdgeInsets.symmetric(vertical: 10),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     // Üst başlık
     Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
       "CİZGİ FİLMLER & ANİMELER", // Sabit metin
       style: AppTextstyle.allDecksBaslik // Sabit stil
      ),
     ),
     // OPTİMİZASYON 2: BlocBuilder içeriği ayrı bir widget'a taşındı.
     _DeckContentLoader(),
    ],
   ),
  );
 }
}

/// Veri yükleme durumlarını yöneten ve BlocBuilder'ı içeren yardımcı widget.
class _DeckContentLoader extends StatelessWidget {
 const _DeckContentLoader();

 @override
 Widget build(BuildContext context) {
  return Container(
   // Sabit renk ve yükseklik const yapıldı.
   color: AppColors.allDecksBackground,
   height: SizeHelper.categoryDeckHeight, 
   child: BlocBuilder<CizgiFilmAnimeDecksCubit, CizgiFilmAnimeDecksState>(
    builder: (context, state) {
     if (state is CizgiFilmAnimeDecksLoading) {
      // OPTİMİZASYON 3: Yükleme göstergesi const yapıldı.
      return const Center(child: CircularProgressIndicator());
     }
     if (state is CizgiFilmAnimeDecksLoadFailure) {
      return Center(
       child: Text(
        state.errorMessage,
        // OPTİMİZASYON 4: Hata metni stilinin bir kısmı const yapıldı.
        style: const TextStyle(fontSize: 16, color: Colors.red),
       ),
      );
     }
     if (state is CizgiFilmAnimeDecksLoaded) {
      // Veri yüklendiğinde ayrı ListView widget'ını çağır.
      return _DeckListView(decks: state.decks);
     }
     // OPTİMİZASYON 5: Varsayılan geri dönüş const yapıldı.
     return const SizedBox.shrink();
    },
   ),
  );
 }
}

/// Yüklü desteleri yatay ListView.builder ile gösteren yardımcı widget.
class _DeckListView extends StatelessWidget {
 final List<DeckEntity> decks;
 const _DeckListView({required this.decks});

 @override
 Widget build(BuildContext context) {
  return ListView.builder(
   // OPTİMİZASYON 6: ListView özellikleri const yapıldı.
   scrollDirection: Axis.horizontal,
   padding: const EdgeInsets.symmetric(horizontal: 16.0),
   itemCount: decks.length,
   itemBuilder: (context, index) {
    // OPTİMİZASYON 7: Padding ve sabit genişlik const yapıldı.
    return Padding(
     padding: const EdgeInsets.only(right: 12),
     child: SizedBox(
      width: SizeHelper.categoryDeckWidth,
      child: DeckCover(deck: decks[index]),
     ),
    );
   },
  );
 }
}