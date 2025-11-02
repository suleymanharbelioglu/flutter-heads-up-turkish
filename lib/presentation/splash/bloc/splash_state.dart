import 'package:flutter/material.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

// Uygulama ayarları yüklenirken (genellikle I/O işlemleri)
class SplashLoading extends SplashState {} 

// Tüm işlemler bitti, navigasyona hazır
class SplashNavigate extends SplashState {}
