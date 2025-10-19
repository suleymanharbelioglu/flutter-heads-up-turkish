import 'package:ben_kimim/data/card/source/card_service.dart';
import 'package:ben_kimim/domain/card/repository/card_repo.dart';
import 'package:ben_kimim/service_locator.dart';
import 'package:dartz/dartz.dart';

class CardRepoImpl extends CardRepo {
  @override
  Future<Either> getCurrentCardNameList(String nameFilePath) async {
    return await sl<CardService>().getCurrentCardNameList(nameFilePath);
  }
}
