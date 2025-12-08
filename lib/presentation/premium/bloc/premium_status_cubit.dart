import 'dart:async';
import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumStatusCubit extends Cubit<PremiumStatusState> {
  PremiumStatusCubit() : super(PremiumLoading()) {
    print("premium status cubit .................");

    _listenPurchaseStream();
    checkPremiumStatus();
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> checkPremiumStatus() async {
    emit(PremiumLoading());
    print("premiumstatuscubit loading .........................");
    try {
      await _iap.restorePurchases();
    } catch (e) {
      emit(PremiumStatusFailure("Premium kontrol edilirken hata: $e"));
      print("premiumstatuscubit failure .........................");
    }
  }

  void _listenPurchaseStream() async {
    print("premiumstatuscubit loading .........................");

    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      emit(PremiumStatusFailure("Satın alma hizmeti cihazda kullanılamıyor."));
      print("premiumstatuscubit failure .........................");

      return;
    }

    _subscription?.cancel();

    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        final activePurchases = purchases
            .where((purchase) =>
                purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)
            .toList();

        if (activePurchases.isEmpty) {
          emit(PremiumInactive());
          print("premiumstatuscubit inactive .........................");
        } else {
          final lastPurchase = activePurchases.last;
          final model = PurchaseModel.fromPurchaseDetails(lastPurchase);

          if (model.isActive) {
            emit(PremiumActive(model));
            print("premiumstatuscubit active .........................");
          } else {
            emit(PremiumInactive());
            print("premiumstatuscubit inactive .........................");
          }
        }

        for (var purchase in purchases) {
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }
        }
      },
      onError: (error) {
        emit(PremiumStatusFailure(error.toString()));
      },
      onDone: () {
        print("Premium satın alma akışı kapandı.");
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
