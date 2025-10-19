abstract class DisplayCurrentCardListState {}

class DisplayCurrentCardListInitial extends DisplayCurrentCardListState {}

class DisplayCurrentCardListLoading extends DisplayCurrentCardListState {}

class DisplayCurrentCardListLoaded extends DisplayCurrentCardListState {
  final List<String> names;
  DisplayCurrentCardListLoaded(this.names);
}

class DisplayCurrentCardListError extends DisplayCurrentCardListState {
  final String message;
  DisplayCurrentCardListError(this.message);
}