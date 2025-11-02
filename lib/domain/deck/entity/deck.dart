import 'dart:ui';

class DeckEntity {
  final List<String> categoryNameList; // artık liste
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)
  final String deckDescription; // Yeni alan
  final Color deckTextColor; // Yeni alan

  DeckEntity({
    required this.deckName,
    required this.categoryNameList,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
    required this.deckDescription,
    required this.deckTextColor,
  });

  @override
  String toString() {
    return "categoryNameList: ${categoryNameList.join(', ')}";
  }
}
