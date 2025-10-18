import 'dart:convert';

import 'package:ben_kimim/data/deck/model/deck.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

abstract class DeckService {
  Future<Either> getC1Decks();
  Future<Either> getC2Decks();
  Future<Either> getC3Decks();
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
  Future<Either<String, List<DeckEntity>>> getC1Decks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(decks.where((d) => d.categoryName == 'C1').toList()),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getC2Decks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(decks.where((d) => d.categoryName == 'C2').toList()),
    );
  }

  @override
  Future<Either<String, List<DeckEntity>>> getC3Decks() async {
    final result = await _loadDecks();
    return result.fold(
      (l) => Left(l),
      (decks) => Right(decks.where((d) => d.categoryName == 'C3').toList()),
    );
  }
}
