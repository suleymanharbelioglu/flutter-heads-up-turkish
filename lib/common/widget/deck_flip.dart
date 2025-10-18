import 'dart:math';
import 'dart:ui'; // Blur için
import 'package:flutter/material.dart';
import 'package:ben_kimim/domain/deck/entity/deck.dart';

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

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flipAnim = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _autoFlip() {
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (mounted) {
        await _controller.forward();
        setState(() {
          isFront = false;
          canTap = true;
        });
      }
    });
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
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackgroundTapLayer(),
            _buildBlurBackground(),
            _buildCard(),
          ],
        ),
      ),
    );
  }

  /// 1️⃣ Boşluğa basınca kapanan layer
  Widget _buildBackgroundTapLayer() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _flipBackAndClose,
    );
  }

  /// 2️⃣ Blur arka plan
  Widget _buildBlurBackground() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(color: Colors.black.withOpacity(0.3)),
    );
  }

  /// 3️⃣ Kart ve dönüş animasyonu
  Widget _buildCard() {
    return Center(
      child: Hero(
        tag: widget.deck.onGorselAdress,
        child: AnimatedBuilder(
          animation: _flipAnim,
          builder: (context, child) {
            final isBack = _flipAnim.value > pi / 2;

            return GestureDetector(
              onTap: () {}, // Kartın kendisine basıldığında kapanmasın
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnim.value),
                alignment: Alignment.center,
                child: Container(
                  width: 350,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 30),
                    ],
                    image: DecorationImage(
                      image: AssetImage(widget.deck.onGorselAdress),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: isBack ? _buildBackSide() : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Arka yüz ve butonlar
  Widget _buildBackSide() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Stack(
        children: [
          _buildBackImage(),
          _buildBackButton(),
          _buildPlayButton(),
        ],
      ),
    );
  }

  Widget _buildBackImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(widget.deck.arkaGorselAdress),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: GestureDetector(
        onTap: _flipBackAndClose,
        child: AnimatedScale(
          scale: canTap ? 1 : 0.9,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Geri",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: GestureDetector(
        onTap: () {
          // Oyna butonu kapanmayı engeller
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Oyna",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
