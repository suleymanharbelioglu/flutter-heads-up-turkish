import 'package:ben_kimim/domain/deck/usecases/get_c3_decks.dart';
import 'package:ben_kimim/presentation/home/bloc/c3_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C3DecksCubit extends Cubit<C3DecksState> {
  C3DecksCubit() : super(C3Initial());

  void loadC3Decks() async {
    print("loadc3decks cubit");
    emit(C3DecksLoading());
    var returnedData = await sl<GetC3DecksUseCase>().call();
    returnedData.fold(
      (error) {
        emit(C3DecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(C3DecksLoaded(decks: data));
      },
    );
  }
}
