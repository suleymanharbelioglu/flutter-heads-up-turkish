 import 'package:ben_kimim/domain/deck/entity/deck.dart';

class DiziFilmDecksState {}

 class DiziFilmInitial extends DiziFilmDecksState {}
 class DiziFilmDecksLoading extends DiziFilmDecksState {}
 class DiziFilmDecksLoaded extends DiziFilmDecksState {
  final List<DeckEntity> decks;

  DiziFilmDecksLoaded({required this.decks});
 }
 class DiziFilmDecksLoadFailure extends DiziFilmDecksState {
 final String errorMessage;

  DiziFilmDecksLoadFailure({required this.errorMessage});
 }