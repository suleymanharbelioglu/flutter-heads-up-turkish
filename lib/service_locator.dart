import 'package:ben_kimim/data/card/repository/card_repo_impl.dart';
import 'package:ben_kimim/data/card/source/card_service.dart';
import 'package:ben_kimim/data/deck/repository/deck_repo_impl.dart';
import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/card/repository/card_repo.dart';
import 'package:ben_kimim/domain/card/usecase/get_current_card_name_list.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/domain/deck/usecases/get_Popular_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_canlandir_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_dizi_film_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_muzik_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_spor_decks.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  // service
  sl.registerSingleton<DeckService>(DeckServiceImpl());
  sl.registerSingleton<CardService>(CardServiceImpl());
  //repo
  sl.registerSingleton<DeckRepo>(DeckRepoImpl());
  sl.registerSingleton<CardRepo>(CardRepoImpl());

  // usecase
  sl.registerSingleton<GetPopularDecksUseCase>(GetPopularDecksUseCase());
  sl.registerSingleton<GetMuzikDecksUseCase>(GetMuzikDecksUseCase());
  sl.registerSingleton<GetDiziFilmDecksUseCase>(GetDiziFilmDecksUseCase());
  sl.registerSingleton<GetSporDecksUseCase>(GetSporDecksUseCase());
  sl.registerSingleton<GetCanlandirDecksUseCase>(GetCanlandirDecksUseCase());

  sl.registerSingleton<GetCurrentCardNameListUseCase>(
    GetCurrentCardNameListUseCase(),
  );
}
