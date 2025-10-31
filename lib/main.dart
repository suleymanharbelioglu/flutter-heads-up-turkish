import 'package:ben_kimim/core/configs/theme/app_theme.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/canlandir_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/dizi_film_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/muzik_decks_cubit.dart';
import 'package:ben_kimim/presentation/all_decks/bloc/spor_decks_cubit.dart';
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
        BlocProvider(create: (context) => SplashCubit()..startSplash()),
        BlocProvider(create: (context) => TimerCubit()),
        BlocProvider(create: (context) => DisplayCurrentCardListCubit()),
        BlocProvider(create: (context) => ScoreCubit()),
        BlocProvider(create: (context) => ResultCubit()),
        BlocProvider(
          create: (context) =>
              CurrentNameCubit(context.read<DisplayCurrentCardListCubit>()),
        ),
        BlocProvider(create: (context) => MuzikDecksCubit()..loadMuzikDecks()),
        BlocProvider(
          create: (context) => DiziFilmDecksCubit()..loadDiziFilmDecks(),
        ),
        BlocProvider(create: (context) => SporDecksCubit()..loadSporDecks()),
        BlocProvider(
          create: (context) => CanlandirDecksCubit()..loadCanlandirDecks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        title: 'Ben Kimim',
        home: SplashPage(),
      ),
    );
  }
}
