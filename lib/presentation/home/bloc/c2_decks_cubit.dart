import 'package:ben_kimim/domain/deck/usecases/get_c2_decks.dart';
import 'package:ben_kimim/presentation/home/bloc/c2_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class C2DecksCubit extends Cubit<C2DecksState> {
  C2DecksCubit() : super(C2Initial());

  void loadC2Decks() async {
    print("loadc2decks cubit");
    emit(C2DecksLoading());
    var returnedData = await sl<GetC2DecksUseCase>().call();
    returnedData.fold(
      (error) {
        emit(C2DecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(C2DecksLoaded(decks: data));
      },
    );
  }
}
