import 'package:dartz/dartz.dart';

abstract class DeckRepo {
  Future<Either> getPopularDecks();
  Future<Either> getMuzikDecks();
  Future<Either> getSporDecks();
  Future<Either> getCanlandirDecks();
  Future<Either> getDiziFilmDecks();
  Future<Either> getGunlukYasamDecks();
  Future<Either> getBilimVeGenelKDecks();
  Future<Either> getCizDecks();
  Future<Either> getUnlulerDecks();
  Future<Either> getYemeklerDecks();
  Future<Either> getCizgiFilmAnimeDecks();
}
