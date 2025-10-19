import 'package:dartz/dartz.dart';

abstract class CardRepo {
  Future<Either> getCurrentCardNameList(String nameFilePath);

}