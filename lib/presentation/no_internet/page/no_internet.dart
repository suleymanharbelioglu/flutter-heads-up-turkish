import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/presentation/bottom_nav/page/bottom_nav.dart';
import 'package:ben_kimim/presentation/no_internet/bloc/internet_connection_cubit.dart';
import 'package:ben_kimim/presentation/no_internet/bloc/internet_connection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Geri tuşunu engelle
      onWillPop: () async => false,
      child: BlocListener<InternetConnectionCubit, InternetConnectionState>(
        listener: (context, state) {
          if (state is InternetConnected) {
            print("go to No internet page ---------------------");
            // İnternet yoksa NoInternetPage'e yönlendir
            AppNavigator.push(context, BottomNavPage());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.1), // Saydam arka plan
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5, // Yarı ekran
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "İnternet bağlantınızı kontrol edin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
