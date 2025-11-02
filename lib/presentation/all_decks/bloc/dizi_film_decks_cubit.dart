import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiziFilmDecksCubit extends Cubit<DiziFilmDecksState> {
  DiziFilmDecksCubit() : super(DiziFilmInitial());

  Future<void> loadDiziFilmDecks() async {
    emit(DiziFilmDecksLoading());
    var returnedData = await sl<DeckRepo>().getDiziFilmDecks();
    returnedData.fold(
      (error) {
        emit(DiziFilmDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(DiziFilmDecksLoaded(decks: data));
      },
    );
  }
}
