import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/bilim_ve_genelk_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/canlandir_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/ciz_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/cizgi_film_anime_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/dizi_film_deck.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/gunluk_yasam_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/muzik_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/popular_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/spor_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/unluler_decks.dart';
import 'package:ben_kimim/presentation/all_decks/widgets/yemekler_decks.dart';
import 'package:flutter/material.dart';

class AllDecksPage extends StatelessWidget {
  const AllDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.allDecksBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tahmin Et!"),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PopularDecks(),
            MuzikDecks(),
            DiziFilmDecks(),
            CanlandirDecks(),
            SporDecks(),
            GunlukYasamDecks(),
            BilimVeGenelKDecks(),
            CizDecks(),
            UnlulerDecks(),
            YemeklerDecks(),
            CizgiFilmAnimeDecks()
          ],
        ),
      ),
    );
  }
}
