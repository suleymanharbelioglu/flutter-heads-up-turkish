import 'package:ben_kimim/core/usecase/usecase.dart';
import 'package:ben_kimim/domain/card/repository/card_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetCurrentCardNameListUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<CardRepo>().getCurrentCardNameList(params!);
  }
}
