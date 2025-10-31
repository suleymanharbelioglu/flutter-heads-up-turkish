import 'package:ben_kimim/domain/deck/usecases/get_dizi_film_decks.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiziFilmDecksCubit extends Cubit<DiziFilmDecksState> {
  DiziFilmDecksCubit() : super(DiziFilmInitial());

  void loadDiziFilmDecks() async {
    print("loadDiziFilmdecks cubit");
    emit(DiziFilmDecksLoading());
    var returnedData = await sl<GetDiziFilmDecksUseCase>().call();
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
