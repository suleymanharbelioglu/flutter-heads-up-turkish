class CardResultModel {
  final String word; // kelime
  final bool isCorrect; // doğru mu (true) yoksa pass mi (false)

  CardResultModel({required this.word, required this.isCorrect});
}
