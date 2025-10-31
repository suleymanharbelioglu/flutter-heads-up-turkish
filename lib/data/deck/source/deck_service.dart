import 'dart:convert';

import 'package:ben_kimim/data/deck/model/deck.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

abstract class DeckService {
  Future<Either> getPopularDecks();
  Future<Either> getMuzikDecks();
  Future<Either> getDiziFilmDecks();
  Future<Either> getSporDecks();
  Future<Either> getCanlandirDecks();
}

class DeckServiceImpl extends DeckService {
  Future<Either<String, List<DeckEntity>>> _loadDecks() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/decks.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final decks = jsonList
          .map((e) => DeckModel.fromJson(e).toEntity())
          .toList();
      return Right(decks);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getPopularDecks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(
        decks.where((d) => d.categoryNameList.contains('Popular')).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getDiziFilmDecks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(
        decks.where((d) => d.categoryNameList.contains('Dizi/Film')).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getMuzikDecks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(
        decks.where((d) => d.categoryNameList.contains('Müzik')).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getSporDecks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(
        decks.where((d) => d.categoryNameList.contains('Spor')).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getCanlandirDecks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(
        decks.where((d) => d.categoryNameList.contains('Canlandır')).toList(),
      ),
    );
  }
}
