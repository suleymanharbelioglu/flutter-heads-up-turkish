// deck_cover.dart
import 'package:ben_kimim/common/widget/deck/deck_flip.dart';
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DeckCover extends StatelessWidget {
  final DeckEntity deck;
  const DeckCover({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DeckFlip(deck: deck),
            opaque: false,
            barrierColor: Colors.black.withOpacity(0.3),
            // 👆 transitionsBuilder kaldırıldı
          ),
        );
      },
      child: Hero(
        tag: deck.onGorselAdress,
        child: Container(
          width: 140,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(deck.onGorselAdress),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
