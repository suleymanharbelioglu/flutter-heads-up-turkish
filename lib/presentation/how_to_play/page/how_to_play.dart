import 'package:ben_kimim/common/navigator/app_navigator.dart';
import 'package:ben_kimim/core/configs/assets/app_images.dart';
import 'package:ben_kimim/presentation/home/pages/all_decks.dart';
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
          children: [
            InstructionItem(
              description:
                  "Telefonu alnınıza yerleştirin. Arkadaşlarınız kelimeyi anlatırken, şarkı söyleyerek veya hareketlerle ipuçları verirken tahmin etmeye çalışın.",
              imagePath: AppImages.game,
            ),
            const SizedBox(height: 40),
            InstructionItem(
              description:
                  "Kelimeyi doğru bildiğinizde telefonu aşağı doğru eğin.",
              imagePath: AppImages.correct,
            ),
            const SizedBox(height: 40),
            InstructionItem(
              description:
                  "Pass geçmek isterseniz telefonu yukarı doğru kaldırın.",
              imagePath: AppImages.pass,
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 240,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    AppNavigator.push(context, AllDecksPage());
                  },
                  child: const Text(
                    "Devam Et",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
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
