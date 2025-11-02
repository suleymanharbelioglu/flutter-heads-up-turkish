import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void startSplash() async {
    print("splash cubit");
    await Future.delayed(const Duration(seconds: 1));
    emit(SplashNavigate());
  }
}
