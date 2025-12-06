import 'package:ben_kimim/data/app_purchase/model/product_model.dart';

abstract class LoadProductsState {}

class LoadProductsInitial extends LoadProductsState {}

class LoadProductsLoading extends LoadProductsState {}

class LoadProductsSuccess extends LoadProductsState {
  final List<ProductModel> products;

  LoadProductsSuccess({required this.products});
}

class LoadProductsFailure extends LoadProductsState {
  final String message;

  LoadProductsFailure({required this.message});
}
