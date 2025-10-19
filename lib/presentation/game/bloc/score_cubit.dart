// score_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreCubit extends Cubit<int> {
  ScoreCubit() : super(0); // Başlangıç skoru 0

  /// Skoru 1 artırır
  void increment() => emit(state + 1);

  /// Skoru sıfırlar
  void reset() => emit(0);
}
