// bottom_nav_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(1); // başlangıç: 1. sayfa

  void changePage(int index) => emit(index);
}
