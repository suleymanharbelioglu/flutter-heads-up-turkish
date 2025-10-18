import 'package:ben_kimim/presentation/home/bloc/c1_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/c2_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/bloc/c3_decks_cubit.dart';
import 'package:ben_kimim/presentation/home/widgets/c1_decks.dart';
import 'package:ben_kimim/presentation/home/widgets/c2_decks.dart';
import 'package:ben_kimim/presentation/home/widgets/c3_decks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => C1DecksCubit()..loadC1Decks()),
        BlocProvider(create: (context) => C2DecksCubit()..loadC2Decks()),
        BlocProvider(create: (context) => C3DecksCubit()..loadC3Decks()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [SizedBox(height: 50), C1Decks(), C2Decks(), C3Decks()],
          ),
        ),
      ),
    );
  }
}
