// bottom_nav_cubit.dart
import 'package:ben_kimim/common/helper/sound/sound.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(1); // başlangıç: 1. sayfa

  Future<void> changePage(int index) async {
    await SoundHelper.playClick();

    emit(index);
  }
}
