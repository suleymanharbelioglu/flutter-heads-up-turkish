class DeckEntity {
  final String categoryName;
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final List<String> names; // Tahmin edilecek isimler

  DeckEntity({
    required this.deckName,
    required this.categoryName,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    required this.names, // artık zorunlu
  });
}
