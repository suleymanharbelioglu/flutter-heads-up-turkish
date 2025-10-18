import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) ;

  void startSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(SplashNavigate());
  }
}
