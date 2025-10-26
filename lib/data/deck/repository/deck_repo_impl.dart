import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeckRepoImpl  extends DeckRepo{
  @override
  Future<Either> getPopularDecks() async {
    return await sl<DeckService>().getPopularDecks();
  }
  
 
}