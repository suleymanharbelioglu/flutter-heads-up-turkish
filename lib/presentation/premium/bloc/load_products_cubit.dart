import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:ben_kimim/domain/app_purchase/repository/purchase_repository.dart';
import 'package:ben_kimim/presentation/premium/bloc/load_products_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

class LoadProductsCubit extends Cubit<LoadProductsState> {
  LoadProductsCubit() : super(LoadProductsInitial());
  final productIds = [
    'weekly_premium',
    'monthly_premium',
    'yearly_premium',
  ];

  /// Ürün ID listesi vererek ürünleri yükle
  Future<void> loadProducts() async {
    emit(LoadProductsLoading()); // Önce loading state

    // Google Play servisinden ürünleri çek
    Either<String, List<ProductModel>> result =
        await sl<PurchaseRepository>().loadProducts(productIds);

    result.fold(
      (error) =>
          emit(LoadProductsFailure(message: error)), // Hata varsa failure state
      (products) => emit(
          LoadProductsSuccess(products: products)), // Başarılıysa success state
    );
  }
}
