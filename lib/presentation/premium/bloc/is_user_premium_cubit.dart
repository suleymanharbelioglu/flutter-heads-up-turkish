import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'premium_status_cubit.dart'; // PremiumStatusCubit import et
import 'premium_status_state.dart'; // PremiumActive vs için

class IsUserPremiumCubit extends Cubit<bool> {
  late final StreamSubscription _subscription;

  // PremiumStatusCubit'i constructor ile alıyoruz
  IsUserPremiumCubit(PremiumStatusCubit premiumStatusCubit) : super(false) {
    // PremiumStatusCubit'in stream'ini dinle
    _subscription = premiumStatusCubit.stream.listen((state) {
      if (state is PremiumActive) {
        emit(true); // premium aktifse true
      } else if (state is PremiumInactive) {
        emit(false); // premium değilse false
      }
      // hata durumunda istersen false bırakabilirsin
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel(); // stream dinlemesini iptal et
    return super.close();
  }
}
