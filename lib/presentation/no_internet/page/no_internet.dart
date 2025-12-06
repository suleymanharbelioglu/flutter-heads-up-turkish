import 'package:ben_kimim/presentation/no_internet/bloc/internet_connection_cubit.dart';
import 'package:ben_kimim/presentation/no_internet/bloc/internet_connection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ↩ geri tuşu kapalı
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.45),
        body: BlocListener<InternetConnectionCubit, InternetConnectionState>(
          listener: (context, state) {
            if (state is InternetConnected) {
              Navigator.of(context).pop(); // ↩ internet gelince kapanacak
            }
          },
          child: Center(
            child: FadeTransition(
              opacity: Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(
                  parent: _controller, curve: Curves.easeInOut)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width * 0.83,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                      color: Colors.black.withOpacity(0.18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 📶 Offline Icon
                    ScaleTransition(
                      scale: Tween(begin: 0.93, end: 1.05).animate(
                          CurvedAnimation(
                              parent: _controller, curve: Curves.easeInOut)),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 65,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Title
                    const Text(
                      "İnternet Bağlantısı Yok",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description
                    Text(
                      "Lütfen internet bağlantınızı kontrol edin.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
