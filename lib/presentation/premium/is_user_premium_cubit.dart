import 'package:flutter_bloc/flutter_bloc.dart';

class IsUserPremiumCubit extends Cubit<bool> {
  IsUserPremiumCubit() : super(false); // Başlangıçta ücretsiz kullanıcı

  void setPremium(bool value) {
    emit(value);
  }
}
