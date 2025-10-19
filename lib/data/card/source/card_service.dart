import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

abstract class CardService {
  Future<Either> getCurrentCardNameList(String nameFilePath);
}


class CardServiceImpl extends CardService {
  @override
  Future<Either<String, List<String>>> getCurrentCardNameList(String nameFilePath) async {
    try {
      // JSON dosyasını oku
      final data = await rootBundle.loadString(nameFilePath);

      // JSON'u decode et
      final jsonResult = json.decode(data);

      // names alanını al
      if (jsonResult['names'] != null) {
        final List<String> names = List<String>.from(jsonResult['names']);
        return Right(names); // Başarılı
      } else {
        return Left('JSON içinde "names" alanı bulunamadı');
      }
    } catch (e) {
      return Left('İsim listesi okunamadı: $e');
    }
  }
}