import 'package:ben_kimim/core/usecase/usecase.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetDiziFilmDecksUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<DeckRepo>().getDiziFilmDecks();
  }
}
