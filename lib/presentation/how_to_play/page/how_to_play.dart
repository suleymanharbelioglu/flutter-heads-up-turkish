import 'package:ben_kimim/core/configs/assets/app_images.dart';
import 'package:flutter/material.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Nasıl Oynanır?"),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InstructionItem(
              description:
                  "  Oynamak istediğin desteyi seç. Telefonu alnına yerleştir. Deste kartındaki kurallara göre kelimeyi tahmin et!",
              imagePath: AppImages.game,
            ),
            const SizedBox(height: 40),
            InstructionItem(
              description:
                  "  Kelimeyi doğru bilirsen telefonun ekranını aşağı doğru çevir.",
              imagePath: AppImages.correct,
            ),
            const SizedBox(height: 40),
            InstructionItem(
              description:
                  "  Pass geçmek için telefonun ekranını yukarı doğru çevir.",
              imagePath: AppImages.pass,
            ),
          ],
        ),
      ),
    );
  }
}

class InstructionItem extends StatelessWidget {
  final String description;
  final String imagePath;

  const InstructionItem({
    super.key,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            imagePath,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
