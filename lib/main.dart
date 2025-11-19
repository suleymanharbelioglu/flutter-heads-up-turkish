import 'package:ben_kimim/core/configs/theme/app_theme.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/bilim_ve_genelk_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/canlandir_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/ciz_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/cizgifilm_anime_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/gunluk_yasam_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/popular_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/spor_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/unluler_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/yemeker_decks_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/score_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart';
import 'package:ben_kimim/presentation/game_result/bloc/result_cubit.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_cubit.dart';
import 'package:ben_kimim/presentation/splash/pages/splash.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // varsayılan dikey
  ]);
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // startSplash() çağrısı SplashPage'e taşındı. Sadece Cubit oluşturuluyor.
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (context) => TimerCubit()),
        BlocProvider(create: (context) => DisplayCurrentCardListCubit()),
        BlocProvider(create: (context) => ScoreCubit()),
        BlocProvider(create: (context) => ResultCubit()),
        BlocProvider(
          create: (context) =>
              CurrentNameCubit(context.read<DisplayCurrentCardListCubit>()),
        ),
        // KRİTİK DEĞİŞİKLİK: TÜM YÜKLEME ÇAĞRILARI BURADAN KALDIRILDI.
        BlocProvider(
          create: (context) => PopularDecksCubit(),
        ),
        BlocProvider(create: (context) => MuzikDecksCubit()),
        BlocProvider(create: (context) => SporDecksCubit()),
        BlocProvider(
          create: (context) => DiziFilmDecksCubit(),
        ),
        BlocProvider(
          create: (context) => CanlandirDecksCubit(),
        ),
        BlocProvider(
          create: (context) => GunlukYasamDecksCubit(),
        ),
        BlocProvider(
          create: (context) => BilimVeGenelKDecksCubit(),
        ),
        BlocProvider(
          create: (context) => CizDecksCubit(),
        ),
        BlocProvider(
          create: (context) => UnlulerDecksCubit(),
        ),
        BlocProvider(
          create: (context) => YemeklerDecksCubit(),
        ),
        BlocProvider(
          create: (context) => CizgiFilmAnimeDecksCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Projenizdeki temanın doğru yolu: lib/config/theme.dart'ı referans alarak import etmelisiniz.
        // Konuşma geçmişine göre: import 'package:ben_kimim/core/configs/theme/app_theme.dart';
        theme: AppTheme.appTheme,
        title: 'Ben Kimim',
        home: SplashPage(),
      ),
    );
  }
}
