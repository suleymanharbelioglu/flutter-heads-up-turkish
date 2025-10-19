import 'package:ben_kimim/data/card/repository/card_repo_impl.dart';
import 'package:ben_kimim/data/card/source/card_service.dart';
import 'package:ben_kimim/data/deck/repository/deck_repo_impl.dart';
import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/card/repository/card_repo.dart';
import 'package:ben_kimim/domain/card/usecase/get_current_card_name_list.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c1_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c2_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c3_decks.dart';
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
  sl.registerSingleton<GetC1DecksUseCase>(GetC1DecksUseCase());
  sl.registerSingleton<GetC2DecksUseCase>(GetC2DecksUseCase());
  sl.registerSingleton<GetC3DecksUseCase>(GetC3DecksUseCase());
  sl.registerSingleton<GetCurrentCardNameListUseCase>(
    GetCurrentCardNameListUseCase(),
  );
}
