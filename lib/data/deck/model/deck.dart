
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckModel {
  final String categoryName;
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)

  DeckModel({
    required this.deckName,
    required this.categoryName,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckName: json['deckName'] as String,
      categoryName: json['categoryName'] as String,
      onGorselAdress: json['onGorselAdress'] as String,
      arkaGorselAdress: json['arkaGorselAdress'] as String,
      namesFilePath: json['namesFilePath'] as String,
    );
  }

  DeckEntity toEntity() {
    return DeckEntity(
      deckName: deckName,
      categoryName: categoryName,
      onGorselAdress: onGorselAdress,
      arkaGorselAdress: arkaGorselAdress,
      namesFilePath: namesFilePath,
    );
  }
}