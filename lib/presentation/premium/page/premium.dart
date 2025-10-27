import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A1E87), // Mor arka plan
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Taç ikonu + VIP başlık
              Column(
                children: const [
                  Icon(Icons.workspace_premium, color: Colors.amber, size: 80),
                  SizedBox(height: 10),
                  Text(
                    "PREMİUM PLAN",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Özellikler
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.style, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Tüm desteleri oyna",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.block, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Tüm reklamları kaldır",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
                ],
              ),

              const SizedBox(height: 30),

              // Fiyat seçenekleri
              Expanded(
                child: ListView(
                  children: [
                    _buildPlanTile(
                      title: "Haftalık",
                      price: "₺104,99",
                      selected: false,
                    ),
                    _buildPlanTile(
                      title: "Aylık",
                      price: "₺349,99",
                      oldPrice: "₺499,99",
                      discount: "-30%",
                      selected: true,
                    ),
                    _buildPlanTile(
                      title: "Yıllık",
                      price: "₺699,99",
                      oldPrice: "₺1.749,99",
                      discount: "-60%",
                      selected: false,
                    ),
                    _buildPlanTile(
                      title: "Süresiz",
                      price: "₺1.659,99",
                      oldPrice: "₺5.533,30",
                      discount: "-70%",
                      subTitle: "Kalıcı erişim",
                      selected: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Başlat butonu
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  "Şimdi Başla",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Alt bağlantılar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Gizlilik Politikası",
                    style: TextStyle(
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Kullanım Şartları",
                    style: TextStyle(
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Text(
                "Satın alımı geri yükle",
                style: TextStyle(
                  color: Colors.white70,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Plan kutusu widget'ı
  Widget _buildPlanTile({
    required String title,
    required String price,
    String? oldPrice,
    String? discount,
    String? subTitle,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF5136C2) : const Color(0xFF2E1760),
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(color: Colors.amberAccent, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Başlık + alt açıklama
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
          ),

          // Fiyatlar
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (oldPrice != null)
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              if (discount != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
