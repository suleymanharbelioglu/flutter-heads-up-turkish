import 'dart:async';
import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Hata düzeltmesi: Artık 'QueryPurchaseDetailsResponse' yerine 
/// 'restorePurchases()' metodu stream'i tetikler.
class PremiumStatusCubit extends Cubit<PremiumStatusState> {
  PremiumStatusCubit() : super(PremiumInitial()) {
    // 1. Sürekli dinlemeyi başlat (Bu, Cubit'in yaşam döngüsü boyunca aktiftir).
    _listenPurchaseStream(); 
    // 2. Dinleme başladıktan hemen sonra, mevcut abonelikleri sorgula (stream'i tetikler).
    checkPremiumStatus(); 
  }

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Geçmiş satın almaları sorgular ve sonuçları stream'e (akışa) iletir.
  /// Not: Bu metot artık doğrudan bir Response objesi döndürmez, bunun yerine
  /// sonuçlar _listenPurchaseStream metoduna gider.
  
  Future<void> checkPremiumStatus() async {
    // UI'a yüklenme durumunu göster.
    if (state is! PremiumLoading) {
      emit(PremiumLoading());
    }

    try {
      // restorePurchases, geçmiş satın alımları alıp sonuçları purchaseStream'e iter.
      // Bu, _listenPurchaseStream metodunu tetikleyecektir.
      await _iap.restorePurchases();
      
      // Akışın durumu güncellemesi beklenir. Eğer akış boş sonuç döndürürse, 
      // _listenPurchaseStream metodu içerisindeki mantık PremiumInactive yayını yapacaktır.

    } catch (e) {
      // İşlem başlatma sırasında hata oluşursa.
      emit(PremiumStatusFailure("Premium kontrol edilirken hata: $e"));
    }
  }

  /// Satın alma stream'ini sürekli dinler. Yeni bir satın alma, geri yükleme veya 
  /// abonelik durumu değişikliği olduğunda bu metot çalışır.
  void _listenPurchaseStream() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      emit(PremiumStatusFailure("Satın alma hizmeti cihazda kullanılamıyor."));
      return;
    }
    
    _subscription?.cancel();

    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        
        // Yalnızca aktif ve tamamlanmış (Purchased veya Restored) satın almaları filtrele.
        final activePurchases = purchases
            .where((purchase) => 
                purchase.status == PurchaseStatus.purchased || 
                purchase.status == PurchaseStatus.restored)
            .toList();

        if (activePurchases.isEmpty) {
          // Aktif satın alma detayı yoksa (üyelik bitti veya hiç yok).
          
          emit(PremiumInactive());
        } else {
          // Aktif satın alma varsa, en sonuncuyu al.
          final lastPurchase = activePurchases.last;
          final model = PurchaseModel.fromPurchaseDetails(lastPurchase);
          
          // Aktif olup olmadığını kontrol et ve state'i güncelle.
          // Not: PurchaseModel içerisindeki isActive kontrolü bu aşamada çok önemlidir.
          if (model.isActive) {
            emit(PremiumActive(model));
          } else {
             // Satın alma detayı geldi ama model (uygulama mantığına göre) artık aktif değil.
             emit(PremiumInactive());
          }
        }

        // Satın alma tamamlanmamışsa tamamla
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
      }
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // stream iptal
    return super.close();
  }
}