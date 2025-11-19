

import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/cizgifilm_anime_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CizgiFilmAnimeDecksCubit extends Cubit<CizgiFilmAnimeDecksState> {
  CizgiFilmAnimeDecksCubit() : super(CizgiFilmAnimeInitial());

  Future<void> loadCizgiFilmAnimeDecks() async {
    emit(CizgiFilmAnimeDecksLoading());
    var returnedData = await sl<DeckRepo>().getCizgiFilmAnimeDecks();
    returnedData.fold(
      (error) {
        emit(CizgiFilmAnimeDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(CizgiFilmAnimeDecksLoaded(decks: data));
      },
    );
  }
}
