 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class PopularDecksState {}

 class PopularInitial extends PopularDecksState {}
 class PopularDecksLoading extends PopularDecksState {}
 class PopularDecksLoaded extends PopularDecksState {
  final List<DeckEntity> decks;

  PopularDecksLoaded({required this.decks});
 }
 class PopularDecksLoadFailure extends PopularDecksState {
 final String errorMessage;

  PopularDecksLoadFailure({required this.errorMessage});
 }