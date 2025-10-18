import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'deck_flip.dart'; // flip sayfası

class DeckCover extends StatelessWidget {
  final DeckEntity deck;
  const DeckCover({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => DeckFlip(deck: deck),
          ),
        );
      },
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
