import 'package:dartz/dartz.dart';

abstract class DeckRepo {
  Future<Either> getPopularDecks();
  
}
