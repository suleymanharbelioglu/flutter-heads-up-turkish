import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';

abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseInProgress extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {
  final PurchaseModel purchase;
  PurchaseSuccess({required this.purchase});
}

class PurchaseFailure extends PurchaseState {
  final String message;
  PurchaseFailure({required this.message});
}