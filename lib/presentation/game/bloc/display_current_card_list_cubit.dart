import 'dart:math';
import 'package:ben_kimim/domain/card/usecase/get_current_card_name_list.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_state.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

// 2️⃣ Cubit
class DisplayCurrentCardListCubit extends Cubit<DisplayCurrentCardListState> {
  DisplayCurrentCardListCubit() : super(DisplayCurrentCardListInitial());

  final Random _random = Random();
  List<String> _allNames = []; // Tam liste
  List<String> _availableNames = []; // Tekrar etmeyecek liste

  /// JSON'dan isimleri yükle
  Future<void> loadCardNames(String nameFilePath) async {
    emit(DisplayCurrentCardListLoading());

    final Either result = await sl<GetCurrentCardNameListUseCase>().call(
      params: nameFilePath,
    );

    result.fold(
      (failure) => emit(DisplayCurrentCardListError(failure.toString())),
      (names) {
        _allNames = List<String>.from(names);
        _availableNames = List<String>.from(names);
        emit(DisplayCurrentCardListLoaded(_allNames));
      },
    );
  }

  /// Tekrar etmeyecek random isim, liste bitince baştan doldurur
  String getRandomName() {
    if (_availableNames.isEmpty) {
      _availableNames = List<String>.from(_allNames);
    }

    final index = _random.nextInt(_availableNames.length);
    final name = _availableNames[index];
    _availableNames.removeAt(index);
    print("${_availableNames.length} ...............");
    print("${_availableNames.toString()} ...............");
    return name;
  }

  /// Cubit ve listeleri tamamen resetle
  void reset() {
    print("isim lsitsi resetlendi.............. ");
    _allNames.clear();
    _availableNames.clear();
    emit(DisplayCurrentCardListInitial());
  }
}
