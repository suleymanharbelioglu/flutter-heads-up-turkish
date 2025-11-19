import 'package:ben_kimim/data/deck/source/deck_service.dart';
import 'package:ben_kimim/domain/deck/repository/deck_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeckRepoImpl extends DeckRepo {
  @override
  Future<Either> getPopularDecks() async {
    return await sl<DeckService>().getPopularDecks();
  }

  @override
  Future<Either> getMuzikDecks() async {
    return await sl<DeckService>().getMuzikDecks();
  }

  @override
  Future<Either> getCanlandirDecks() async {
    return await sl<DeckService>().getCanlandirDecks();
  }

  @override
  Future<Either> getDiziFilmDecks() async {
    return await sl<DeckService>().getDiziFilmDecks();
  }

  @override
  Future<Either> getSporDecks() async {
    return await sl<DeckService>().getSporDecks();
  }

  @override
  Future<Either> getBilimVeGenelKDecks() async {
    return await sl<DeckService>().getBilimVeGenelKDecks();
  }

  @override
  Future<Either> getGunlukYasamDecks() async {
    return await sl<DeckService>().getGunlukYasamDecks();
  }

  @override
  Future<Either> getCizDecks() async {
    return await sl<DeckService>().getCizDecks();
  }
}
