import 'dart:async';

import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:ben_kimim/presentation/premium/bloc/purchase_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit() : super(PurchaseInitial());

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Satın alma işlemini başlat ve sadece bu işlem için dinle
  Future<void> purchaseProduct(String productId) async {
    emit(PurchaseInProgress());

    try {
      // Ürün detaylarını çek
      final response = await _iap.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty) {
        emit(PurchaseFailure(message: 'Product not found: $productId'));
        return;
      }

      final productDetails = response.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      // Stream'i başlat sadece bu satın alma için
      _subscription = _iap.purchaseStream.listen((purchases) {
        for (var purchase in purchases) {
          final model = PurchaseModel.fromPurchaseDetails(purchase);

          if (model.isActive) {
            emit(PurchaseSuccess(purchase: model));
          } else {
            emit(PurchaseFailure(message: 'Purchase not completed.'));
          }

          // Satın alma onayı varsa tamamla
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase);
          }

          // İşlem tamamlandı, stream dinlemesini kapat
          _subscription?.cancel();
          _subscription = null;
        }
      }, onError: (error) {
        emit(PurchaseFailure(message: error.toString()));
        _subscription?.cancel();
        _subscription = null;
      });

      // Satın alma başlat
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      emit(PurchaseFailure(message: 'Error purchasing product: $e'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
