import 'package:dartz/dartz.dart';

abstract class DeckRepo {
Future<Either> getC1Decks();
  Future<Either> getC2Decks();
  Future<Either> getC3Decks();}