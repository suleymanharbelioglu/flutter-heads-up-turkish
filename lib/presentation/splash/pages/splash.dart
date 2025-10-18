import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/presentation/home/pages/home.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_cubit.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigate) {
          AppNavigator.pushAndRemove(context, HomePage());
        }
      },
      child: Scaffold(body: Center(child: Text("Splash Screen"))),
    );
  }
}
