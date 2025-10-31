import 'package:flutter/material.dart';

class DeckEntity {
  final List<String> categoryNameList; // Değiştirildi
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)
  final String deckDescription; // Yeni alan
  final Color deckTextColor; // Yeni alan

  DeckEntity({
    required this.deckName,
    required this.categoryNameList, // Güncellendi
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
    required this.deckDescription,
    required this.deckTextColor,
  });
}
