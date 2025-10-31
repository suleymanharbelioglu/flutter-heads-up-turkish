import 'package:ben_kimim/domain/deck/usecases/get_Canlandir_decks.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/canlandir_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanlandirDecksCubit extends Cubit<CanlandirDecksState> {
  CanlandirDecksCubit() : super(CanlandirInitial());

  void loadCanlandirDecks() async {
    print("loadCanlandirdecks cubit");
    emit(CanlandirDecksLoading());
    var returnedData = await sl<GetCanlandirDecksUseCase>().call();
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
