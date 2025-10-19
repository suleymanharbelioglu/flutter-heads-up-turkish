import 'dart:math';
import 'dart:ui';
import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/phone_to_forhead/page/phone_to_forhead.dart';
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckFlip extends StatefulWidget {
  final DeckEntity deck;
  const DeckFlip({super.key, required this.deck});

  @override
  State<DeckFlip> createState() => _DeckFlipState();
}

class _DeckFlipState extends State<DeckFlip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnim;
  bool isFront = true;
  bool canTap = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _autoFlip();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackAction,
      child: Scaffold(
        // 1️⃣ ARKAPLAN ARTIK SİYAH DEĞİL, SAYDAM + BLUR
        backgroundColor: Colors.black.withOpacity(0.2),
        body: Stack(
          children: [
            // Arka plan bulanıklığı efekti
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            // Kart ortada
            Center(
              child: AnimatedBuilder(
                animation: _flipAnim,
                builder: (context, child) {
                  final isBack = _flipAnim.value > pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    // 2️⃣ Artık sağa kaymıyor, sadece merkezde dönüyor
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_flipAnim.value),
                    child: isBack ? buildBackCard() : buildFrontCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ön yüz (Hero animasyonu burada)
  Widget buildFrontCard() {
    return Hero(
      tag: widget.deck.onGorselAdress,
      child: _buildCard(widget.deck.onGorselAdress, null),
    );
  }

  /// Arka yüz
  Widget buildBackCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: _buildCard(widget.deck.arkaGorselAdress, _buildButtons()),
    );
  }

  /// Ortak kart tasarımı
  Widget _buildCard(String imagePath, Widget? child) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 20)],
      ),
      child: child,
    );
  }

  /// Geri ve Oyna butonları
  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(
                text: "Geri",
                color: Colors.black54,
                textColor: Colors.white,
                onTap: _flipBackAndClose,
              ),
              _buildButton(
                text: "Oyna",
                color: Colors.greenAccent.withOpacity(0.9),
                textColor: Colors.black,
                onTap: () async {
                  // 1️⃣ İsim listesini yükle (deste JSON path ver)
                  await context
                      .read<DisplayCurrentCardListCubit>()
                      .loadCardNames(widget.deck.namesFilePath);
                  AppNavigator.push(context, PhoneToForeheadPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flipAnim = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> _autoFlip() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      await _controller.forward();
      setState(() {
        isFront = false;
        canTap = true;
      });
    }
  }

  Future<void> _flipBackAndClose() async {
    if (!canTap) return;
    setState(() => canTap = false);

    if (!isFront) {
      await _controller.reverse();
      isFront = true;
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<bool> _handleBackAction() async {
    await _flipBackAndClose();
    return false;
  }
}
