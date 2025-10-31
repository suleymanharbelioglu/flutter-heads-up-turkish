import 'package:dartz/dartz.dart';

abstract class DeckRepo {
  Future<Either> getPopularDecks();
  Future<Either> getMuzikDecks();
  Future<Either> getDiziFilmDecks();
  Future<Either> getSporDecks();
  Future<Either> getCanlandirDecks();
}
