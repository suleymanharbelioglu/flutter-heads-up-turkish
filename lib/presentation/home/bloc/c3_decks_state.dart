
import 'package:ben_kimim/domain/deck/entity/deck.dart';

class C3DecksState {}

class C3Initial extends C3DecksState {}

class C3DecksLoading extends C3DecksState {}

class C3DecksLoaded extends C3DecksState {
  final List<DeckEntity> decks;

  C3DecksLoaded({required this.decks});
}

class C3DecksLoadFailure extends C3DecksState {
  final String errorMessage;

  C3DecksLoadFailure({required this.errorMessage});
}
