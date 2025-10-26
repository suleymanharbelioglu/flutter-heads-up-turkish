import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/core/configs/assets/app_images.dart';
import 'package:ben_kimim/presentation/home/pages/all_decks.dart';
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
          // Sayfa geçişini burada yapıyoruz
          AppNavigator.pushAndRemove(context, const AllDecksPage());
        }
      },
      // Scaffold, arka plan görselini ve yükleme göstergesini barındıracak
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand, // Stack'i ekran boyutuna genişlet
          children: [
            // 1. Arka Plan Görseli
            Image.asset(
              AppImages.splashBackground,
              fit: BoxFit.cover, // Görselin tüm ekranı kaplamasını sağlar
            ),

            // 2. Yükleme Göstergesi (Alt Orta Kısım)
            Align(
              alignment: Alignment.bottomCenter, // Alt ortaya hizala
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 50.0,
                ), // Alttan biraz yukarı it
                child: CircularProgressIndicator(
                  color:
                      Colors.white, // Yükleme göstergesinin rengini beyaz yap
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
