import 'dart:ui';
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckModel {
  final List<String> categoryNameList; // artık liste
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath;
  final String deckDescription;
  final Color deckTextColor;

  DeckModel({
    required this.deckName,
    required this.categoryNameList,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
    required this.deckDescription,
    required this.deckTextColor,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckName: json['deckName'] as String,
      categoryNameList: List<String>.from(json['categoryNameList'] ?? []), // listeye çevir
      onGorselAdress: json['onGorselAdress'] as String,
      arkaGorselAdress: json['arkaGorselAdress'] as String,
      namesFilePath: json['namesFilePath'] as String,
      deckDescription: json['deckDescription'] as String,
      deckTextColor: Color(
        int.parse(json['deckTextColor'] as String),
      ),
    );
  }

  DeckEntity toEntity() {
    return DeckEntity(
      deckName: deckName,
      categoryNameList: categoryNameList,
      onGorselAdress: onGorselAdress,
      arkaGorselAdress: arkaGorselAdress,
      namesFilePath: namesFilePath,
      deckDescription: deckDescription,
      deckTextColor: deckTextColor,
    );
  }
}
