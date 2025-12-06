import 'package:in_app_purchase/in_app_purchase.dart';

/// PURCHASE MODEL
/// Kullanıcının satın aldığı ürünün bilgilerini tutar.
/// Bu modeli kendi domain katmanında kullanırsın.
/// UI veya repository içinde PurchaseDetails yerine bu model döner.

class PurchaseModel {
  /// Google Play ürün ID'si (örn: weekly_premium)
  final String productId;

  /// Satın alma başarılı mı?
  final bool isActive;

  /// Satın alma zamanı (milisaniye formatında gelir)
  final DateTime purchaseDate;

  /// Abonelik mi tek seferlik ürün mü?
  final bool isSubscription;

  PurchaseModel({
    required this.productId,
    required this.isActive,
    required this.purchaseDate,
    required this.isSubscription,
  });

  /// PurchaseDetails → PurchaseModel dönüşümü
  factory PurchaseModel.fromPurchaseDetails(dynamic purchase) {
    return PurchaseModel(
      productId: purchase.productID,
      isActive: purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored,

      /// Google'dan timestamp ms cinsinden gelir
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(purchase.transactionDate ?? "0") ?? 0,
      ),

      /// Abonelik olup olmadığını anlamak için (play billing destekliyor)
      isSubscription: purchase.productID.contains("premium") ||
          purchase.verificationData.localVerificationData.contains("SUBS"),
    );
  }
}
