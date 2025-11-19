

import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/unluler_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnlulerDecksCubit extends Cubit<UnlulerDecksState> {
  UnlulerDecksCubit() : super(UnlulerInitial());

  Future<void> loadUnlulerDecks() async {
    emit(UnlulerDecksLoading());
    var returnedData = await sl<DeckRepo>().getUnlulerDecks();
    returnedData.fold(
      (error) {
        emit(UnlulerDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(UnlulerDecksLoaded(decks: data));
      },
    );
  }
}
