import 'package:flutter_bloc/flutter_bloc.dart';

enum PlanType { weekly, monthly, yearly }

class PlanCubit extends Cubit<PlanType?> {
  PlanCubit() : super(PlanType.weekly); // varsayılan haftalık seçili

  void selectPlan(PlanType plan) {
    emit(plan);
  }
}
