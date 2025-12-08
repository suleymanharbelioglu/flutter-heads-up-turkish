import 'package:ben_kimim/common/helper/sound/sound.dart';
import 'package:ben_kimim/common/widget/deck/deck_flip.dart';
import 'package:ben_kimim/presentation/bottom_nav/bloc/bottom_nav_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/is_user_premium_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckCover extends StatelessWidget {
  final DeckEntity deck;
  const DeckCover({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await precacheImage(AssetImage(deck.onGorselAdress), context);
        await precacheImage(AssetImage(deck.arkaGorselAdress), context);
        await SoundHelper.playClick();

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BlocProvider.value(
              value: context.read<BottomNavCubit>(),
              child: DeckFlip(deck: deck),
            ),
            opaque: false,
            barrierColor: const Color(0x4D000000),
          ),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: "image_${deck.deckName}",
            child: _HeroImageWrapper(
              imagePath: deck.onGorselAdress,
            ),
          ),
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Hero(
              tag: "title_${deck.deckName}",
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Stack(
                    children: [
                      Text(
                        deck.deckName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        deck.deckName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<IsUserPremiumCubit, bool>(
            
            builder: (context, userIsPremium) {
              if (deck.isPremium && !userIsPremium) {
                return Positioned(
                  right: 8,
                  bottom: 8,
                  child: Hero(
                    tag: "lock_${deck.deckName}",
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _HeroImageWrapper extends StatelessWidget {
  final String imagePath;
  const _HeroImageWrapper({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
