import 'package:ben_kimim/presentation/all_decks/pages/all_decks.dart';
import 'package:ben_kimim/presentation/how_to_play/page/how_to_play.dart';
import 'package:ben_kimim/presentation/premium/page/premium.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    PremiumPage(),
    AllDecksPage(),
    HowToPlayPage(),
  ];
  @override
  void initState() {
    super.initState();
    // Portrait modunu kilitle
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor, // seçili renk (primaryColor)
        unselectedItemColor: Colors.grey, // seçilmemiş renk (gri)
        iconSize: 28, // ikon boyutu
        selectedFontSize: 14,
        unselectedFontSize: 13,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.crown),
            label: 'VIP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            label: 'Desteler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Nasıl Oynanır',
          ),
        ],
      ),
    );
  }
}
