import 'dart:async';

import 'package:ben_kimim/common/helper/sound/sound.dart';
import 'package:ben_kimim/core/configs/theme/app_color.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_cubit.dart';
import 'package:ben_kimim/presentation/game/bloc/display_current_card_list_state.dart';
import 'package:ben_kimim/presentation/game/page/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PhoneToForeheadPage extends StatefulWidget {
  const PhoneToForeheadPage({super.key});

  @override
  State<PhoneToForeheadPage> createState() => _PhoneToForeheadPageState();
}

class _PhoneToForeheadPageState extends State<PhoneToForeheadPage> {
  int countdown = 4;
  Timer? _timer;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription<DisplayCurrentCardListState>? _cubitSubscription;
  bool countdownStarted = false;

  // Pozisyon sınırları
  final double minX = 7;
  final double maxX = 10;
  final double minY = -5;
  final double maxY = 5;
  final double minZ = -4;
  final double maxZ = 5;

  @override
  void initState() {
    super.initState();
    // Yalnızca yatay mod
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      if (!countdownStarted) {
        bool inPositionNow =
            event.x >= minX &&
            event.x <= maxX &&
            event.y >= minY &&
            event.y <= maxY &&
            event.z >= minZ &&
            event.z <= maxZ;

        if (inPositionNow) {
          countdownStarted = true;
          startCountdown();
          startCountDownSound();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Geri tuşunu devre dışı bırakır
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: countdownStarted
              ? Text(
                  '$countdown',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'TELEFONU ALNINIZA YERLEŞTİRİN',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }

  Future<void> startCountDownSound() async {
    await Future.delayed(const Duration(seconds: 1));
    await SoundHelper.playCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => countdown--);

      if (countdown == 0) {
        _timer?.cancel();

        final cubit = context.read<DisplayCurrentCardListCubit>();

        // Cubit subscription
        _cubitSubscription = cubit.stream.listen((state) {
          if (state is DisplayCurrentCardListLoaded) {
            _cubitSubscription?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GamePage()),
            );
          } else if (state is DisplayCurrentCardListError) {
            _cubitSubscription?.cancel();
            // Hata mesajını göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });

        // Eğer zaten loaded ise anında geçiş
        if (cubit.state is DisplayCurrentCardListLoaded) {
          _cubitSubscription?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GamePage()),
          );
        } else if (cubit.state is DisplayCurrentCardListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: ${(cubit.state as DisplayCurrentCardListError).message}",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _timer?.cancel();
    _cubitSubscription?.cancel();
    super.dispose();
  }
}
