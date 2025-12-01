import 'dart:async';
import 'package:ben_kimim/presentation/no_internet/bloc/internet_connection_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  late StreamSubscription _subscription;

  InternetConnectionCubit() : super(InternetConnected()) {
    // Başlangıçta internet durumu kontrol et
    _checkInitialConnection();

    // İnternet değişikliklerini dinle
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      print("package result ---------------------------- $result");
      if (result[0] == ConnectivityResult.none) {
        print("disssssssssssssssssss");

        emit(InternetDisConnected());
      } else {
        print("connected ........................");
        emit(InternetConnected());
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    print("package result ---------------------------- $result");

    if (result[0] == ConnectivityResult.none) {
      print("disssssssssssssssssss");

      emit(InternetDisConnected());
    } else {
      print("connected ........................");

      emit(InternetConnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
