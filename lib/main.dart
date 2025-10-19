import 'package:ben_kimim/core/configs/theme/app_theme.dart';
import 'package:ben_kimim/presentation/game/bloc/current_name_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_cubit.dart';
import 'package:ben_kimim/presentation/splash/pages/splash.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider(create: (context) => DisplayCurrentCardListCubit()),
        BlocProvider(
          create: (context) =>
              CurrentNameCubit(context.read<DisplayCurrentCardListCubit>()),
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
