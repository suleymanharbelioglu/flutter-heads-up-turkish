import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/canlandir_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/gunluk_yasam_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/popular_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/spor_decks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  // Context, MultiBlocProvider'da oluşturulan diğer Cubit'lere erişim için gereklidir.
  void startSplash(BuildContext context) async {
    try {
      print("Splash Cubit: Başlatılıyor.");

      // 1. Durumu Yükleniyor olarak ayarla
      // SplashState.dart dosyasının SplashLoading durumunu içerdiğinden emin olun.
      emit(SplashLoading());

      // 2. TÜM DECK YÜKLEME İŞLEMLERİNİ ASENKRON OLARAK BAŞLAT VE BEKLE
      print("Tüm oyun desteleri yükleniyor... (Asenkron)");

      // Cubit'lere erişim
      final popularDecksCubit = context.read<PopularDecksCubit>();
      final muzikDecksCubit = context.read<MuzikDecksCubit>();
      final sporDecksCubit = context.read<SporDecksCubit>();
      final diziFilmDecksCubit = context.read<DiziFilmDecksCubit>();
      final canlandirDecksCubit = context.read<CanlandirDecksCubit>();
      final gunlukYasamDecksCubit = context.read<GunlukYasamDecksCubit>();
      final bilimVeGenelKDecksCubit = context.read<BilimVeGenelKDecksCubit>();

      // DÜZELTME BURADA: Hata nedeniyle Future.wait'in tip parametresi <void> olarak ayarlandı.
      await Future.wait<void>([
        popularDecksCubit.loadPopularDecks(),
        muzikDecksCubit.loadMuzikDecks(),
        sporDecksCubit.loadSporDecks(),
        diziFilmDecksCubit.loadDiziFilmDecks(),
        canlandirDecksCubit.loadCanlandirDecks(),
        gunlukYasamDecksCubit.loadGunlukYasamDecks(),
        bilimVeGenelKDecksCubit.loadBilimVeGenelKDecks()
      ]);

      // Minimum yükleme süresi bekle (kullanıcı deneyimi için)
      await Future.delayed(const Duration(seconds: 2));

      // 3. Başarılı, navigasyon durumunu yay
      emit(SplashNavigate());
      print("Splash Cubit: Başlatma tamamlandı, navigasyona hazır.");
    } catch (e) {
      print("Uygulama başlatma hatası: $e");
      // Hata olsa bile navigasyon durumunu yayınla
      emit(SplashNavigate());
    }
  }
}
