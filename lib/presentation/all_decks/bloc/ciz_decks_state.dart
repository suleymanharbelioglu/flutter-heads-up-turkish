import 'package:ben_kimim/domain/deck/entity/deck.dart';

class CizDecksState {}

 class CizInitial extends CizDecksState {}
 class CizDecksLoading extends CizDecksState {}
 class CizDecksLoaded extends CizDecksState {
  final List<DeckEntity> decks;

  CizDecksLoaded({required this.decks});
 }
 class CizDecksLoadFailure extends CizDecksState {
 final String errorMessage;

  CizDecksLoadFailure({required this.errorMessage});
 }