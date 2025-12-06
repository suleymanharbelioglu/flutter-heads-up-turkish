import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedPlanCubit extends Cubit<String?> {
  SelectedPlanCubit()
      : super('weekly_premium'); // Başlangıçta haftalık plan seçili

  /// UI üzerinden seçilen planı set eder
  void selectPlan(String productId) {
    print("product id ....................$productId");
    emit(productId);
  }
}
