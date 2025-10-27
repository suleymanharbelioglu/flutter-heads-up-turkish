import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckModel {
  final String categoryName;
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)
  final String deckDescription; // Yeni alan
  final Color deckTextColor; // Yeni alan

  DeckModel({
    required this.deckName,
    required this.categoryName,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
    required this.deckDescription,
    required this.deckTextColor, // constructor’a ekle
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckName: json['deckName'] as String,
      categoryName: json['categoryName'] as String,
      onGorselAdress: json['onGorselAdress'] as String,
      arkaGorselAdress: json['arkaGorselAdress'] as String,
      namesFilePath: json['namesFilePath'] as String,
      deckDescription: json['deckDescription'] as String,
      deckTextColor: Color(int.parse(json['deckTextColor'])), // JSON’dan çevir
    );
  }

  DeckEntity toEntity() {
    return DeckEntity(
      deckName: deckName,
      categoryName: categoryName,
      onGorselAdress: onGorselAdress,
      arkaGorselAdress: arkaGorselAdress,
      namesFilePath: namesFilePath,
      deckDescription: deckDescription,
      deckTextColor: deckTextColor, // Entity’ye ekle
    );
  }
}
