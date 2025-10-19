import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentNameCubit extends Cubit<String> {
  final DisplayCurrentCardListCubit _listCubit;

  CurrentNameCubit(this._listCubit) : super(''); // Başlangıçta boş

  /// Yeni random isim üret
  void generateNewName() {
    if (_listCubit.state is DisplayCurrentCardListLoaded) {
      final name = _listCubit.getRandomName();
      emit(name);
    } else {
      emit(''); // Liste yüklenmemişse boş
    }
  }

  /// Cubit reset
  void reset() => emit('');
}