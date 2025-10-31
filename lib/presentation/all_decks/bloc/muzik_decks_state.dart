 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class MuzikDecksState {}

 class MuzikInitial extends MuzikDecksState {}
 class MuzikDecksLoading extends MuzikDecksState {}
 class MuzikDecksLoaded extends MuzikDecksState {
  final List<DeckEntity> decks;

  MuzikDecksLoaded({required this.decks});
 }
 class MuzikDecksLoadFailure extends MuzikDecksState {
 final String errorMessage;

  MuzikDecksLoadFailure({required this.errorMessage});
 }