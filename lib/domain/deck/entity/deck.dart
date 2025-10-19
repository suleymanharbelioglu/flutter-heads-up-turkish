class DeckEntity {
  final String categoryName;
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final String namesFilePath; // JSON dosya yolu (zorunlu)

  DeckEntity({
    required this.deckName,
    required this.categoryName,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.namesFilePath,
  });
}