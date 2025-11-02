import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/gunluk_yasam_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GunlukYasamDecksCubit extends Cubit<GunlukYasamDecksState> {
  GunlukYasamDecksCubit() : super(GunlukYasamInitial());

  Future<void> loadGunlukYasamDecks() async {
    emit(GunlukYasamDecksLoading());
    var returnedData = await sl<DeckRepo>().getGunlukYasamDecks();
    returnedData.fold(
      (error) {
        emit(GunlukYasamDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(GunlukYasamDecksLoaded(decks: data));
      },
    );
  }
}
