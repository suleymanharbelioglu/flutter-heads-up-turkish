 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class SporDecksState {}

 class SporInitial extends SporDecksState {}
 class SporDecksLoading extends SporDecksState {}
 class SporDecksLoaded extends SporDecksState {
  final List<DeckEntity> decks;

  SporDecksLoaded({required this.decks});
 }
 class SporDecksLoadFailure extends SporDecksState {
 final String errorMessage;

  SporDecksLoadFailure({required this.errorMessage});
 }