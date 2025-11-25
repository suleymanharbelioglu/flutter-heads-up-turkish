import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/core/configs/assets/app_images.dart';
import 'package:ben_kimim/presentation/bottom_nav/page/bottom_nav.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_cubit.dart';
import 'package:ben_kimim/presentation/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Portrait modunu kilitle (main.dart'ta da olduğu için burada tekrar olmasına gerek yok, ama dursun.)
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // KRİTİK DEĞİŞİKLİK: Yükleme işlemini buradan başlatıyoruz.
    // Cubit'in asenkron yükleme görevini (startSplash) bu noktada tetikliyoruz.
    context.read<SplashCubit>().startSplash(context);

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigate) {
          // Yükleme bitti, BottomNavPage'e geçiş yap
          AppNavigator.pushAndRemove(context, const BottomNavPage());
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand, // Stack'i ekran boyutuna genişlet
          children: [
            // 1. Arka Plan Görseli
            // Not: AppImages.splashBackground tanımlı olmalıdır.
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
                  // Bu rengi beyaz bıraktık, böylece arka planda görünür.
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
