import 'package:ben_kimim/data/deck/repository/deck_repo_impl.dart';
import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c1_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c2_decks.dart';
import 'package:ben_kimim/domain/deck/usecases/get_c3_decks.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  // service
  sl.registerSingleton<DeckService>(DeckServiceImpl());
  //repo
  sl.registerSingleton<DeckRepo>(DeckRepoImpl());

  // usecase
  sl.registerSingleton<GetC1DecksUseCase>(GetC1DecksUseCase());
  sl.registerSingleton<GetC2DecksUseCase>(GetC2DecksUseCase());
  sl.registerSingleton<GetC3DecksUseCase>(GetC3DecksUseCase());
}
