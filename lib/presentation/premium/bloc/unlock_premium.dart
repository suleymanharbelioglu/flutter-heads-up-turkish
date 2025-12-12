import 'package:flutter_bloc/flutter_bloc.dart';

class UnlockPremiumCubit extends Cubit<bool> {
  UnlockPremiumCubit() : super(false);

  void unlock() => emit(true);

  void reset() => emit(false);
}
