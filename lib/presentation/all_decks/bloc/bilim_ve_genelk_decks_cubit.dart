import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BilimVeGenelKDecksCubit extends Cubit<BilimVeGenelKDecksState> {
  BilimVeGenelKDecksCubit() : super(BilimVeGenelKInitial());

  Future<void> loadBilimVeGenelKDecks() async {
    emit(BilimVeGenelKDecksLoading());
    var returnedData = await sl<DeckRepo>().getBilimVeGenelKDecks();
    returnedData.fold(
      (error) {
        emit(BilimVeGenelKDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(BilimVeGenelKDecksLoaded(decks: data));
      },
    );
  }
}
