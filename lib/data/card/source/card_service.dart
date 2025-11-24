import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

abstract class CardService {
  Future<Either> getCurrentCardNameList(String nameFilePath);
}

class CardServiceImpl extends CardService {
  @override
  Future<Either<String, List<String>>> getCurrentCardNameList(
      String nameFilePath) async {
    try {
      final data = await rootBundle.loadString(nameFilePath);

      final jsonResult = json.decode(data);

      if (jsonResult['names'] != null) {
        final List<String> names = List<String>.from(jsonResult['names']);
        return Right(names);
      } else {
        return Left('JSON içinde "names" alanı bulunamadı');
      }
    } catch (e) {
      return Left('İsim listesi okunamadı: $e');
    }
  }
}
