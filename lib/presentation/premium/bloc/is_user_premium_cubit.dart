import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'premium_status_cubit.dart';
import 'premium_status_state.dart';

class IsUserPremiumCubit extends Cubit<bool> {
  late final StreamSubscription _subscription;

  IsUserPremiumCubit(PremiumStatusCubit premiumStatusCubit) : super(false) {
    // ⭐ 1) PREMIUMSTATUSCUBIT'İN ANLIK STATE'İNİ HEMEN OKU (ÇOK ÖNEMLİ)
    final currentState = premiumStatusCubit.state;
    print("is premium start false................");
    if (currentState is PremiumActive) {
      emit(true);
      print("is premium true ................");
    } else if (currentState is PremiumInactive) {
      emit(false);
      print("is premium false ................");
    }

    // ⭐ 2) SONRADAN GELECEK TÜM STATE’LERİ DİNLE
    _subscription = premiumStatusCubit.stream.listen((state) {
      if (state is PremiumActive) {
        emit(true);
      } else if (state is PremiumInactive) {
        emit(false);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
