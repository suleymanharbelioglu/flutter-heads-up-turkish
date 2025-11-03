import 'dart:math';
import 'dart:ui';
import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/timer_cubit.dart';
import 'package:ben_kimim/presentation/phone_to_forhead/page/phone_to_forhead.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: Colors.black.withOpacity(0.2),
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _flipAnim,
                builder: (context, child) {
                  final isBack = _flipAnim.value > pi / 2;
                  return Transform(
                    alignment: Alignment.center,
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

  Widget buildFrontCard() {
    return Stack(
      children: [
        Hero(
          tag: "image_${widget.deck.deckName}",
          child: _buildCard(widget.deck.onGorselAdress, null),
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Hero(
            tag: "title_${widget.deck.deckName}",
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  widget.deck.deckName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: widget.deck.deckTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBackCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: _buildCard(
        widget.deck.arkaGorselAdress,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                widget.deck.deckName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.deck.deckTextColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      widget.deck.deckDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.deck.deckTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Timer kontrol alanı
                    BlocBuilder<TimerCubit, int>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 40,
                            bottom: 30,
                          ), // alta yakın konum
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                width: 160,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // mavi arka plan (görseldeki gibi)
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // - butonu
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF339CFF), // yeşil ton
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () => context
                                            .read<TimerCubit>()
                                            .decrease(),
                                      ),
                                    ),

                                    // Süre metni
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "${state}s",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF339CFF),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // + butonu
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF339CFF),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () => context
                                            .read<TimerCubit>()
                                            .increase(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

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

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Geri butonu — ok şeklinde arka plan
          GestureDetector(
            onTap: _flipBackAndClose,
            child: CustomPaint(
              painter: _ArrowBackgroundPainter(),
              child: const SizedBox(
                width: 60,
                height: 45,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Oyna butonu (mavi, beyaz kenarlıklı)
          GestureDetector(
            onTap: () async {
              await context.read<DisplayCurrentCardListCubit>().loadCardNames(
                    widget.deck.namesFilePath,
                  );
              AppNavigator.push(context, PhoneToForeheadPage());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007BFF), Color(0xFF339CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "Oyna!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
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
    await Future.delayed(const Duration(milliseconds: 500));
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

class _ArrowBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.75, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
