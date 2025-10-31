import 'package:ben_kimim/domain/deck/usecases/get_Muzik_decks.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuzikDecksCubit extends Cubit<MuzikDecksState> {
  MuzikDecksCubit() : super(MuzikInitial());

  void loadMuzikDecks() async {
    print("loadMuzikdecks cubit");
    emit(MuzikDecksLoading());
    var returnedData = await sl<GetMuzikDecksUseCase>().call();
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
