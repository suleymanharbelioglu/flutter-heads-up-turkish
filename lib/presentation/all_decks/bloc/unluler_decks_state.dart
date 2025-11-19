import 'package:ben_kimim/domain/deck/entity/deck.dart';

class UnlulerDecksState {}

class UnlulerInitial extends UnlulerDecksState {}

class UnlulerDecksLoading extends UnlulerDecksState {}

class UnlulerDecksLoaded extends UnlulerDecksState {
  final List<DeckEntity> decks;

  UnlulerDecksLoaded({required this.decks});
}

class UnlulerDecksLoadFailure extends UnlulerDecksState {
  final String errorMessage;

  UnlulerDecksLoadFailure({required this.errorMessage});
}
