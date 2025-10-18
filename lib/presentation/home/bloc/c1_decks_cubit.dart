import 'package:ben_kimim/domain/deck/usecases/get_c1_decks.dart';
import 'package:ben_kimim/presentation/home/bloc/c1_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C1DecksCubit extends Cubit<C1DecksState> {
  C1DecksCubit() : super(C1Initial());

  void loadC1Decks() async {
    print("loadc1decks cubit");
    emit(C1DecksLoading());
    var returnedData = await sl<GetC1DecksUseCase>().call();
    returnedData.fold(
      (error) {
        emit(C1DecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(C1DecksLoaded(decks: data));
      },
    );
  }
}
