import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeckRepoImpl  extends DeckRepo{
  @override
  Future<Either> getC1Decks() async {
    return await sl<DeckService>().getC1Decks();
  }
  
  @override
  Future<Either> getC2Decks() async {
        return await sl<DeckService>().getC2Decks();

  }
  
  @override
  Future<Either> getC3Decks() async {
       return await sl<DeckService>().getC3Decks();

  }
}