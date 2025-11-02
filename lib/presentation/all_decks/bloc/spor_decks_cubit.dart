import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/spor_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SporDecksCubit extends Cubit<SporDecksState> {
  SporDecksCubit() : super(SporInitial()) {
    print("spor deck cubit constructer");
  }

  void loadSporDecks() async {
    print("load spor deck method");
    emit(SporDecksLoading());
    var returnedData = await sl<DeckRepo>().getSporDecks();
    returnedData.fold(
      (error) {
        emit(SporDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(SporDecksLoaded(decks: data));
      },
    );
  }
}
