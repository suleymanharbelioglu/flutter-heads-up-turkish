import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:ben_kimim/data/app_purchase/source/google_play_purchase_service.dart';
import 'package:ben_kimim/domain/app_purchase/repository/purchase_repository.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  @override
  Future<Either<String, List<ProductModel>>> loadProducts(
      List<String> productIds) async {
    return await sl<GooglePlayPurchaseService>().loadProducts(productIds);
  }
}
