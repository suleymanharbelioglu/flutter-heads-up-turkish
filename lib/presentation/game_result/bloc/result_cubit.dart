import 'package:ben_kimim/data/card/model/card_result.dart';
import 'package:bloc/bloc.dart';

class ResultCubit extends Cubit<List<CardResultModel>> {
  ResultCubit() : super([]);

  void addCorrectWord(String word) {
    emit([...state, CardResultModel(word: word, isCorrect: true)]);
  }

  void addPassWord(String word) {
    emit([...state, CardResultModel(word: word, isCorrect: false)]);
  }

  void reset() => emit([]);
}
