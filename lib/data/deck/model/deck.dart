import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckModel {
  final List<String> categoryNameList; // Değiştirildi
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)
  final String deckDescription; // Yeni alan
  final Color deckTextColor; // Yeni alan

  DeckModel({
    required this.deckName,
    required this.categoryNameList, // Güncellendi
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
    required this.deckDescription,
    required this.deckTextColor,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckName: json['deckName'] as String,
      categoryNameList: List<String>.from(json['categoryNameList']), // Güncellendi
      onGorselAdress: json['onGorselAdress'] as String,
      arkaGorselAdress: json['arkaGorselAdress'] as String,
      namesFilePath: json['namesFilePath'] as String,
      deckDescription: json['deckDescription'] as String,
      deckTextColor: Color(int.parse(json['deckTextColor'])),
    );
  }

  DeckEntity toEntity() {
    return DeckEntity(
      deckName: deckName,
      categoryNameList: categoryNameList, // Güncellendi
      onGorselAdress: onGorselAdress,
      arkaGorselAdress: arkaGorselAdress,
      namesFilePath: namesFilePath,
      deckDescription: deckDescription,
      deckTextColor: deckTextColor,
    );
  }
}
