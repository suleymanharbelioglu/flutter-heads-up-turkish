import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/canlandir_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanlandirDecksCubit extends Cubit<CanlandirDecksState> {
  CanlandirDecksCubit() : super(CanlandirInitial());

  void loadCanlandirDecks() async {
    emit(CanlandirDecksLoading());
    var returnedData = await sl<DeckRepo>().getCanlandirDecks();
    returnedData.fold(
      (error) {
        emit(CanlandirDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(CanlandirDecksLoaded(decks: data));
      },
    );
  }
}
