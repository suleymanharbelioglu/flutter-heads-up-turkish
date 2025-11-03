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
            top: 8, // Üstten mesafe
            left: 0,
            right: 0,
            child: Hero(
              tag: "title_${deck.deckName}",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.topCenter, // Üst merkez
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Taşma önleme
                  child: Text(
                    deck.deckName,
                    textAlign: TextAlign.center, // Ortalanmış text
                    maxLines: 2, // 2 satıra izin
                    overflow: TextOverflow.ellipsis, // Taşarsa … göster
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: deck.deckTextColor,
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
