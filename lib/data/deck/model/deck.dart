import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckModel {
  final String categoryName;
  final String deckName;
  final String onGorselAdress;
  final String arkaGorselAdress;
  final List<String>? names; // Tahmin edilecek isimler (opsiyonel)

  DeckModel({
    required this.deckName,
    required this.categoryName,
    required this.onGorselAdress,
    required this.arkaGorselAdress,
    this.names,
  });

  // JSON'dan oluşturma
  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      deckName: json['deckName'],
      categoryName: json['categoryName'],
      onGorselAdress: json['onGorselAdress'],
      arkaGorselAdress: json['arkaGorselAdress'],
      names: json['names'] != null ? List<String>.from(json['names']) : null,
    );
  }
}

// DeckModel -> DeckEntity dönüşümü
extension DeckModelX on DeckModel {
  DeckEntity toEntity() {
    return DeckEntity(
      deckName: deckName,
      categoryName: categoryName,
      onGorselAdress: onGorselAdress,
      arkaGorselAdress: arkaGorselAdress,
      names: names ?? [], // Eğer names yoksa boş liste
    );
  }
}
