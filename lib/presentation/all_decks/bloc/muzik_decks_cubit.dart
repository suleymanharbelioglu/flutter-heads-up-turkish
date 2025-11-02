import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/Muzik_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuzikDecksCubit extends Cubit<MuzikDecksState> {
  MuzikDecksCubit() : super(MuzikInitial());

  Future<void> loadMuzikDecks() async {
    emit(MuzikDecksLoading());
    var returnedData = await sl<DeckRepo>().getMuzikDecks();
    returnedData.fold(
      (error) {
        emit(MuzikDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(MuzikDecksLoaded(decks: data));
      },
    );
  }
}
