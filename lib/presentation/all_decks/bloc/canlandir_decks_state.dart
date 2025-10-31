 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class CanlandirDecksState {}

 class CanlandirInitial extends CanlandirDecksState {}
 class CanlandirDecksLoading extends CanlandirDecksState {}
 class CanlandirDecksLoaded extends CanlandirDecksState {
  final List<DeckEntity> decks;

  CanlandirDecksLoaded({required this.decks});
 }
 class CanlandirDecksLoadFailure extends CanlandirDecksState {
 final String errorMessage;

  CanlandirDecksLoadFailure({required this.errorMessage});
 }