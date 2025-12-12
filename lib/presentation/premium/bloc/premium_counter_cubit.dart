import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumCounterCubit extends Cubit<int> {
  PremiumCounterCubit() : super(0);

  void increment() {
    print(state);
    emit(state + 1);
  }

  void reset() {
    emit(0);
  }
}
