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
          ),
        );
      },
      child: Stack(
        children: [
          // Görsel Hero
          Hero(
            tag: "image_${deck.deckName}",
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(deck.onGorselAdress),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Başlık Hero
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Hero(
              tag: "title_${deck.deckName}",
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    deck.deckName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 6,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
