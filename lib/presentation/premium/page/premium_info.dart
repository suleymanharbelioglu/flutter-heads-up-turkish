import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumInfoPage extends StatelessWidget {
  final PurchaseModel purchase;
  const PremiumInfoPage({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundGradient(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildInfoCard(),
                const Spacer(),
                _buildFooterMessage(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // BACKGROUND GRADIENT
  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF86D9F6), Color(0xFF0988BF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // PREMIUM ÜYELİK BAŞLIĞI
  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(Icons.workspace_premium, size: 90, color: Colors.white),
        const SizedBox(height: 10),
        Text(
          _getTitle(purchase.productId),
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.black26,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // INFO CARD
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveStatus(),
          const SizedBox(height: 30),

          // ✓ ÇEKLİ MADDELER
          _infoBulletCheck("Reklamsız uygulama kullanımı"),
          const SizedBox(height: 15),

          _infoBulletCheck("Bütün destelere sınırsız erişim"),
          const SizedBox(height: 25),

          // ℹ️ INFO MADDE – productId'ye göre yenilenme bilgisi
          _infoBulletInfo(_getRenewText(purchase.productId)),
          const SizedBox(height: 15),

          _buildGooglePlayLink(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // ACTIVE STATUS BOX
  Widget _buildActiveStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified, color: Colors.green, size: 28),
          SizedBox(width: 10),
          Text(
            "Üyeliğiniz Aktif",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ✓ CHECK ICON MADDE
  Widget _infoBulletCheck(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.orange, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ℹ️ INFO ICON MADDE
  Widget _infoBulletInfo(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info, color: Colors.blue.shade400, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // GOOGLE PLAY LINK
  Widget _buildGooglePlayLink() {
    return GestureDetector(
      onTap: _openGooglePlaySubscriptions,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Colors.blue.shade400, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                children: const [
                  TextSpan(text: "Üyelik işlemlerini "),
                  TextSpan(
                    text: "Google Üyelikler",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(text: " üzerinden yapabilirsiniz."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openGooglePlaySubscriptions() async {
    final Uri url =
        Uri.parse("https://play.google.com/store/account/subscriptions");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // FOOTER
  Widget _buildFooterMessage() {
    return const Text(
      "Üye olduğunuz için teşekkürler!",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ------------------------------------------------------
  //  PRODUCT ID → BAŞLIK
  // ------------------------------------------------------
  String _getTitle(String productId) {
    switch (productId) {
      case 'weekly_premium':
        return 'Haftalık Üyelik';
      case 'monthly_premium':
        return 'Aylık Üyelik';
      case 'yearly_premium':
        return 'Yıllık Üyelik';
      default:
        return 'Premium Üyelik';
    }
  }

  // ------------------------------------------------------
  // PRODUCT ID → YENİLENME AÇIKLAMASI
  // ------------------------------------------------------
  String _getRenewText(String productId) {
    switch (productId) {
      case 'weekly_premium':
        return "Üyeliğiniz iptal edilmediği sürece haftalık olarak yenilenir.";
      case 'monthly_premium':
        return "Üyeliğiniz iptal edilmediği sürece aylık olarak yenilenir.";
      case 'yearly_premium':
        return "Üyeliğiniz iptal edilmediği sürece yıllık olarak yenilenir.";
      default:
        return "Üyeliğiniz iptal edilmediği sürece belirlenen sürede yenilenir.";
    }
  }
}
