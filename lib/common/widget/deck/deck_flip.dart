import 'dart:math';
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flipAnim = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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

  void _flipBackAndClose() async {
    if (!canTap) return;
    setState(() => canTap = false);

    if (!isFront) {
      await _controller.reverse();
      isFront = true;
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Hero(
          tag: widget.deck.onGorselAdress,
          child: AnimatedBuilder(
            animation: _flipAnim,
            builder: (context, child) {
              final isBack = _flipAnim.value > pi / 2;

              // Ana dönüş
              final rotation = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_flipAnim.value);

              return GestureDetector(
                onTap: _flipBackAndClose,
                child: Transform(
                  transform: rotation,
                  alignment: Alignment.center,
                  child: Container(
                    width: 400,
                    height: 700,
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
                    // Arka yüz düz görünmesi için ayrı Transform
                    child: isBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(
                                    widget.deck.arkaGorselAdress,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
