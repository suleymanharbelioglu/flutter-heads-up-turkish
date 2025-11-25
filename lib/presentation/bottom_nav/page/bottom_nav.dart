import 'package:ben_kimim/presentation/all_decks/pages/all_decks.dart';
import 'package:ben_kimim/presentation/how_to_play/page/how_to_play.dart';
import 'package:ben_kimim/presentation/premium/page/premium.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  AdSize? _adSize;

  @override
  void initState() {
    super.initState();

    // Portrait modunu kilitle
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Adaptive Banner yükleme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdaptiveBanner();
    });
  }

  Future<void> _loadAdaptiveBanner() async {
    final double width = MediaQuery.of(context).size.width;

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.truncate(),
    );

    if (size == null) return;

    _adSize = size;

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6970688308215711/7606026846',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: _onTap,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              iconSize: 28,
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

            // ✅ Adaptive Banner (ekran genişliğini kaplar)
            if (_isAdLoaded && _bannerAd != null && _adSize != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _adSize!.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
