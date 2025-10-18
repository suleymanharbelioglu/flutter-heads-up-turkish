import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'deck_flip.dart'; // Kartın arka yüzü sayfası

class DeckCover extends StatelessWidget {
  final DeckEntity deck;
  const DeckCover({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Kart tıklanınca blur'lu şekilde geçiş başlatılır
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // Arka plan şeffaf olur
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: Stack(
                  children: [
                    // Arka plan blur efekti
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.black.withOpacity(0.4)),
                    ),

                    // Asıl sayfa: DeckFlip (arka yüz)
                    DeckFlip(deck: deck),
                  ],
                ),
              );
            },
          ),
        );
      },

      // Kartın ön yüzü
      child: Hero(
        tag: deck.onGorselAdress,
        child: Container(
          width: 140,
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
