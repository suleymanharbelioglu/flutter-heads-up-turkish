import 'dart:async';

import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:dartz/dartz.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class GooglePlayPurchaseService {
  Future<Either<String, List<ProductModel>>> loadProducts(
      List<String> productIds);
      
}

class GooglePlayPurchaseServiceImpl extends GooglePlayPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Future<Either<String, List<ProductModel>>> loadProducts(
      List<String> productIds) async {
    try {
      // Google Play’den ürün detaylarını sorgula
      final response = await _iap.queryProductDetails(productIds.toSet());

      // Eğer ürünler boşsa hata döndür
      if (response.notFoundIDs.isNotEmpty) {
        return Left(
            'Some products not found: ${response.notFoundIDs.join(', ')}');
      }

      // ProductDetails → ProductModel dönüşümü
      final products = response.productDetails
          .map((details) => ProductModel.fromProductDetails(details))
          .toList();

      return Right(products); // Başarılı şekilde liste döndür
    } catch (e) {
      return Left('Error loading products: $e'); // Hata durumunda Left
    }
  }
}
