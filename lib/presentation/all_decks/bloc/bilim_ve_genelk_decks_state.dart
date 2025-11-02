import 'package:ben_kimim/domain/deck/entity/deck.dart';

class BilimVeGenelKDecksState {}

class BilimVeGenelKInitial extends BilimVeGenelKDecksState {}

class BilimVeGenelKDecksLoading extends BilimVeGenelKDecksState {}

class BilimVeGenelKDecksLoaded extends BilimVeGenelKDecksState {
  final List<DeckEntity> decks;

  BilimVeGenelKDecksLoaded({required this.decks});
}

class BilimVeGenelKDecksLoadFailure extends BilimVeGenelKDecksState {
  final String errorMessage;

  BilimVeGenelKDecksLoadFailure({required this.errorMessage});
}
