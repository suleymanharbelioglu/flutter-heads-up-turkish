 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class C2DecksState {}

 class C2Initial extends C2DecksState {}
 class C2DecksLoading extends C2DecksState {}
 class C2DecksLoaded extends C2DecksState {
  final List<DeckEntity> decks;

  C2DecksLoaded({required this.decks});
 }
 class C2DecksLoadFailure extends C2DecksState {
 final String errorMessage;

  C2DecksLoadFailure({required this.errorMessage});
 }