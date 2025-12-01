import 'package:bloc/bloc.dart';

class TimerCubit extends Cubit<int> {
  TimerCubit() : super(60); // Default değer 60 saniye

  /// 15 saniye artır. Maksimum 180
  void increase() {
    if (state + 15 <= 120) {
      emit(state + 15);
    }
  }

  /// 15 saniye azalt. Minimum 15
  void decrease() {
    if (state - 15 >= 30) {
      emit(state - 15);
    }
  }

  /// Timer sıfırlama veya defaulta döndürme
  void reset() {
    emit(60);
  }
}
