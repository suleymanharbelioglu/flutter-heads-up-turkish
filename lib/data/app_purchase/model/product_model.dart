import 'package:in_app_purchase/in_app_purchase.dart';

/// PRODUCT MODEL
/// Google Play’den gelen ürün listesini UI’da göstermek için kullanırsın.
/// Örn: Aylık, Haftalık, Yıllık planların fiyat ve açıklama bilgileri.

class ProductModel {
  /// Google Play ürün ID'si (örn: weekly_premium)
  final String productId;

  /// Ürünün görünen adı (ör: "Haftalık Üyelik")
  final String title;

  /// Ürünün açıklaması (ör: "7 gün premium erişim")
  final String description;

  /// Formatlı fiyat (ör: ₺19,99)
  final String price;

  /// Ham fiyat (ör: 19.99)
  final double rawPrice;

  ProductModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
  });

  factory ProductModel.fromProductDetails(ProductDetails details) {
    return ProductModel(
      productId: details.id,
      title: details.title,
      description: details.description,
      price: details.price,
      rawPrice: details.rawPrice, // ✔ direkt al
    );
  }
}
