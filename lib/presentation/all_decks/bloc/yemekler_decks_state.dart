import 'package:ben_kimim/domain/deck/entity/deck.dart';

class YemeklerDecksState {}

class YemeklerInitial extends YemeklerDecksState {}

class YemeklerDecksLoading extends YemeklerDecksState {}

class YemeklerDecksLoaded extends YemeklerDecksState {
  final List<DeckEntity> decks;

  YemeklerDecksLoaded({required this.decks});
}

class YemeklerDecksLoadFailure extends YemeklerDecksState {
  final String errorMessage;

  YemeklerDecksLoadFailure({required this.errorMessage});
}
