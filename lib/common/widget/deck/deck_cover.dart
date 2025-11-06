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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                deck.onGorselAdress,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                // Resim yüklenene kadar animasyon
                frameBuilder: (BuildContext context, Widget child, int? frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: frame == null
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : child,
                  );
                },
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
                    child: Stack(
                      children: [
                        // Siyah kenarlık (arka katman)
                        Text(
                          deck.deckName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.black, // Kenarlık rengi
                          ),
                        ),
                        // Ana renkli yazı (üst katman)
                        Text(
                          deck.deckName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Orijinal renk
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
