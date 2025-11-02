import 'package:ben_kimim/domain/deck/entity/deck.dart';

class GunlukYasamDecksState {}

class GunlukYasamInitial extends GunlukYasamDecksState {}

class GunlukYasamDecksLoading extends GunlukYasamDecksState {}

class GunlukYasamDecksLoaded extends GunlukYasamDecksState {
  final List<DeckEntity> decks;

  GunlukYasamDecksLoaded({required this.decks});
}

class GunlukYasamDecksLoadFailure extends GunlukYasamDecksState {
  final String errorMessage;

  GunlukYasamDecksLoadFailure({required this.errorMessage});
}
