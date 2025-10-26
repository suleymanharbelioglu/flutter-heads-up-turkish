import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/presentation/home/widgets/popular_decks.dart';
import 'package:ben_kimim/presentation/how_to_play/page/how_to_play.dart';
import 'package:ben_kimim/presentation/premium/page/premium.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllDecksPage extends StatelessWidget {
  const AllDecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.crown,
            color: Colors.white, // Beyaz taç ikonu
          ),
          onPressed: () {
            // Premium sayfasına yönlendirme
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PremiumPage()),
            );
          },
        ),
        title: Text("Tahmin Et!"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white, // Beyaz bilgi ikonu
            ),
            onPressed: () {
              AppNavigator.push(context, HowToPlayPage());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(child: Column(children: [PopularDecks()])),
    );
  }
}
