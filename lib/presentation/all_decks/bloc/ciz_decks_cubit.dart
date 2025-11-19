import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/ciz_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CizDecksCubit extends Cubit<CizDecksState> {
  CizDecksCubit() : super(CizInitial());

  Future<void> loadCizDecks() async {
    emit(CizDecksLoading());
    var returnedData = await sl<DeckRepo>().getCizDecks();
    returnedData.fold(
      (error) {
        emit(CizDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(CizDecksLoaded(decks: data));
      },
    );
  }
}
