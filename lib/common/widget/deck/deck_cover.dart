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
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BlocProvider.value(
              value: context.read<BottomNavCubit>(),
              child: DeckFlip(deck: deck),
            ),
            opaque: false,
            barrierColor: Colors.black.withOpacity(0.3),
          ),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: "image_${deck.deckName}",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                deck.onGorselAdress,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true, // Hero animasyonunu sorunsuz yapar
              ),
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
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
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
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          deck.deckName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          BlocBuilder<IsUserPremiumCubit, bool>(
            builder: (context, userIsPremium) {
              // Deck premium değilse kilit yok
              if (!deck.isPremium) return const SizedBox.shrink();

              // Deck premium ve kullanıcı premium değilse kilit göster
              if (!userIsPremium) {
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

              // Kullanıcı premium ise kilit yok
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
