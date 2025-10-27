import 'package:ben_kimim/presentation/all_decks/widgets/popular_decks.dart';
import 'package:flutter/material.dart';

class AllDecksPage extends StatelessWidget {
  const AllDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tahmin Et!"), actions: [
          
        ],
      ),
      body: SingleChildScrollView(child: Column(children: [PopularDecks()])),
    );
  }
}
