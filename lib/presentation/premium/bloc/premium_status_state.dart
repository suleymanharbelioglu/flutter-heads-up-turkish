import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';

abstract class PremiumStatusState {}

/// Başlangıç durumu (henüz bilgi yok)
class PremiumInitial extends PremiumStatusState {}

/// Premium bilgisi yükleniyor
class PremiumLoading extends PremiumStatusState {}

/// Premium değil → free user
class PremiumInactive extends PremiumStatusState {}

/// Premium aktif → kullanıcı aboneliğe sahip
class PremiumActive extends PremiumStatusState {
  final PurchaseModel purchase;

  PremiumActive(this.purchase);
}
/// Hata durumu
class PremiumStatusFailure extends PremiumStatusState {
  final String message;
  PremiumStatusFailure(this.message);
}