import 'package:ben_kimim/domain/deck/usecases/get_Popular_decks.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/popular_decks_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularDecksCubit extends Cubit<PopularDecksState> {
  PopularDecksCubit() : super(PopularInitial());

  void loadPopularDecks() async {
    print("loadPopulardecks cubit");
    emit(PopularDecksLoading());
    var returnedData = await sl<GetPopularDecksUseCase>().call();
    returnedData.fold(
      (error) {
        emit(PopularDecksLoadFailure(errorMessage: error));
      },
      (data) {
        emit(PopularDecksLoaded(decks: data));
      },
    );
  }
}
