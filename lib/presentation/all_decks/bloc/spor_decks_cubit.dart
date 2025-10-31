import 'package:ben_kimim/domain/deck/usecases/get_Spor_decks.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/spor_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SporDecksCubit extends Cubit<SporDecksState> {
  SporDecksCubit() : super(SporInitial());

  void loadSporDecks() async {
    print("loadSpordecks cubit");
    emit(SporDecksLoading());
    var returnedData = await sl<GetSporDecksUseCase>().call();
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
