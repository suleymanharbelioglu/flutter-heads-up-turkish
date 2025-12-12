import 'package:ben_kimim/presentation/premium/bloc/unlock_premium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecretDialog {
  static Future<void> showSecretDialog(BuildContext context) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Secret Code"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Secret code"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text == "GOOGLE2025") {
                context.read<UnlockPremiumCubit>().unlock();
              }
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
