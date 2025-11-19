

import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/yemekler_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YemeklerDecksCubit extends Cubit<YemeklerDecksState> {
  YemeklerDecksCubit() : super(YemeklerInitial());

  Future<void> loadYemeklerDecks() async {
    emit(YemeklerDecksLoading());
    var returnedData = await sl<DeckRepo>().getYemeklerDecks();
    returnedData.fold(
      (error) {
        emit(YemeklerDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(YemeklerDecksLoaded(decks: data));
      },
    );
  }
}
