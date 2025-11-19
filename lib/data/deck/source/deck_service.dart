import 'dart:convert';
import 'package:ben_kimim/data/deck/model/deck.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // compute() için gerekli

abstract class DeckService {
  Future<Either<String, List<DeckEntity>>> getPopularDecks();
  Future<Either<String, List<DeckEntity>>> getMuzikDecks();
  Future<Either<String, List<DeckEntity>>> getSporDecks();
  Future<Either<String, List<DeckEntity>>> getCanlandirDecks();
  Future<Either<String, List<DeckEntity>>> getDiziFilmDecks();
  Future<Either<String, List<DeckEntity>>> getGunlukYasamDecks();
  Future<Either<String, List<DeckEntity>>> getBilimVeGenelKDecks();
  Future<Either<String, List<DeckEntity>>> getCizDecks();
}

class DeckServiceImpl extends DeckService {
  List<DeckEntity>? _cachedDecks;

  // ✅ Arka planda parse işlemi
  static List<DeckEntity> _parseDecks(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => DeckModel.fromJson(e).toEntity()).toList();
  }

  Future<List<DeckEntity>> _loadDecks() async {
    if (_cachedDecks != null) {
      print("Decks loaded from cache");
      return _cachedDecks!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/decks.json');

      // ✅ JSON parsing işlemini başka isolate’ta yapıyoruz
      _cachedDecks = await compute(_parseDecks, jsonString);

      print("Decks loaded from JSON file");
      return _cachedDecks!;
    } catch (e) {
      print("json file problem: $e");
      rethrow;
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getPopularDecks() async {
    try {
      final result = await _loadDecks();
      final list =
          result.where((d) => d.categoryNameList.contains('Popular')).toList();
      print("Popular deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Popular deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getMuzikDecks() async {
    try {
      final result = await _loadDecks();
      final list =
          result.where((d) => d.categoryNameList.contains('Müzik')).toList();
      print("Müzik deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Müzik deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getCanlandirDecks() async {
    try {
      final result = await _loadDecks();
      final list = result
          .where((d) => d.categoryNameList.contains('Canlandır'))
          .toList();
      print("Canlandır deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Canlandır deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getDiziFilmDecks() async {
    try {
      final result = await _loadDecks();
      final list = result
          .where((d) => d.categoryNameList.contains('Dizi/Film'))
          .toList();
      print("Dizi/Film deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Dizi/Film deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getSporDecks() async {
    print("Spor deck start");
    try {
      final result = await _loadDecks();
      final list =
          result.where((d) => d.categoryNameList.contains('Spor')).toList();
      print("Spor deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Spor deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getBilimVeGenelKDecks() async {
    print("Bilim & Genel Kültür deck start");
    try {
      final result = await _loadDecks();
      final list = result
          .where((d) => d.categoryNameList.contains('Bilim & Genel Kültür'))
          .toList();
      print("Bilim & Genel Kültür deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Bilim & Genel Kültür deck list problem");
    }
  }

  @override
  Future<Either<String, List<DeckEntity>>> getGunlukYasamDecks() async {
    print("Günlük Yaşam deck start");
    try {
      final result = await _loadDecks();
      final list = result
          .where((d) => d.categoryNameList.contains('Günlük Yaşam'))
          .toList();
      print("Günlük Yaşam deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Günlük Yaşam deck list problem");
    }
  }
  
  @override
  Future<Either<String, List<DeckEntity>>> getCizDecks() async {
    print("Ciz deck start");
    try {
      final result = await _loadDecks();
      final list = result
          .where((d) => d.categoryNameList.contains('Ciz'))
          .toList();
      print("Ciz deck count: ${list.length}");
      return Right(list);
    } catch (e) {
      return const Left("Ciz deck list problem");
    }
  }
}
