import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:dartz/dartz.dart';

abstract class PurchaseRepository {
  Future<Either<String, List<ProductModel>>> loadProducts(
      List<String> productIds);
}
