import 'package:ben_kimim/common/widget/deck/deck_flip.dart';
import 'package:ben_kimim/presentation/bottom_nav/bloc/bottom_nav_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/is_user_premium_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckCover extends StatelessWidget {
  final DeckEntity deck;
  // Widget'ın kendisi const olarak tanımlandı.
  const DeckCover({super.key, required this.deck});

  // Performans Optimizasyonu 1: Statik Stilleri build dışına taşıyıp const yapmak.
  // Bu, her build'de Paint ve TextStyle objelerinin yeniden oluşturulmasını engeller.
  static final TextStyle _baseTitleStyle = const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _strokeTitleStyle = _baseTitleStyle.copyWith(
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black,
  );

  static final TextStyle _fillTitleStyle = _baseTitleStyle.copyWith(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Görüntüleri önbelleğe almak, geçiş sırasındaki kasılmayı engeller (iyi pratik).
        await precacheImage(AssetImage(deck.onGorselAdress), context);
        await precacheImage(AssetImage(deck.arkaGorselAdress), context);

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BlocProvider.value(
              value: context.read<BottomNavCubit>(),
              child: DeckFlip(deck: deck),
            ),
            opaque: false,
            // Performans Optimizasyonu 2: Const Color kullanımı.
            barrierColor:
                const Color(0x4D000000), // Colors.black.withOpacity(0.3)
          ),
        );
      },
      child: Stack(
        children: [
          // Arka Plan Resmi (Hero)
          Hero(
            tag: "image_${deck.deckName}",
            child: ClipRRect(
              // Performans Optimizasyonu 3: Const BorderRadius.
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Image.asset(
                deck.onGorselAdress,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
              ),
            ),
          ),

          // Başlık (Hero)
          Positioned(
            // Performans Optimizasyonu 4: Const Positioned değerleri.
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
                      // Başlık Gölge/Kontur (Stroke)
                      Text(
                        deck.deckName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        // Statik stil kullanımı
                        style: _strokeTitleStyle,
                      ),
                      // Başlık Dolgu (Fill)
                      Text(
                        deck.deckName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        // Statik stil kullanımı
                        style: _fillTitleStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Premium Kilit Simgesi
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
                        // Renk dinamik olduğu için (withOpacity) const olamaz.
                        color: Colors.black.withOpacity(0.5),
                        // Performans Optimizasyonu 5: Const BoxShape.
                        shape: BoxShape.circle,
                      ),
                      // Performans Optimizasyonu 6: Const Icon.
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }
              // Performans Optimizasyonu 7: Const SizedBox.shrink().
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
