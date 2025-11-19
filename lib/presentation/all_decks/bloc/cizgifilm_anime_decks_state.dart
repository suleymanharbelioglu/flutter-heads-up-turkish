import 'package:ben_kimim/domain/deck/entity/deck.dart';

class CizgiFilmAnimeDecksState {}

class CizgiFilmAnimeInitial extends CizgiFilmAnimeDecksState {}

class CizgiFilmAnimeDecksLoading extends CizgiFilmAnimeDecksState {}

class CizgiFilmAnimeDecksLoaded extends CizgiFilmAnimeDecksState {
  final List<DeckEntity> decks;

  CizgiFilmAnimeDecksLoaded({required this.decks});
}

class CizgiFilmAnimeDecksLoadFailure extends CizgiFilmAnimeDecksState {
  final String errorMessage;

  CizgiFilmAnimeDecksLoadFailure({required this.errorMessage});
}
