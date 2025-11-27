import 'package:ben_kimim/presentation/all_decks/pages/all_decks.dart';
import 'package:ben_kimim/presentation/bottom_nav/bloc/bottom_nav_cubit.dart';
import 'package:ben_kimim/presentation/how_to_play/page/how_to_play.dart';
import 'package:ben_kimim/presentation/premium/page/premium.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      PremiumPage(),
      AllDecksPage(),
      HowToPlayPage(),
    ];

    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: pages[currentIndex],
            bottomNavigationBar: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomNavigationBar(
                    backgroundColor: Colors.white,
                    currentIndex: currentIndex,
                    onTap: (index) =>
                        context.read<BottomNavCubit>().changePage(index),
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Theme.of(context).primaryColor,
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
                  // Banner reklam
                  BannerContainer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BannerContainer extends StatefulWidget {
  const BannerContainer({super.key});

  @override
  State<BannerContainer> createState() => _BannerContainerState();
}

class _BannerContainerState extends State<BannerContainer> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  AdSize? _adSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBanner();
    });
  }

  Future<void> _loadBanner() async {
    final width = MediaQuery.of(context).size.width;
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width.truncate());
    if (size == null) return;

    _adSize = size;

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6970688308215711/7606026846',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isAdLoaded = true);
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

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null || _adSize == null)
      return const SizedBox.shrink();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
