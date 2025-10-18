 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class C1DecksState {}

 class C1Initial extends C1DecksState {}
 class C1DecksLoading extends C1DecksState {}
 class C1DecksLoaded extends C1DecksState {
  final List<DeckEntity> decks;

  C1DecksLoaded({required this.decks});
 }
 class C1DecksLoadFailure extends C1DecksState {
 final String errorMessage;

  C1DecksLoadFailure({required this.errorMessage});
 }