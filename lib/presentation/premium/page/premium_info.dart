import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumInfoPage extends StatelessWidget {
  final PurchaseModel purchase;
  final ProductModel? product;

  const PremiumInfoPage({
    super.key,
    required this.purchase,
    required this.product,
  });

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
                const SizedBox(height: 8),

                /// *** Manuel fiyat burada ***
                _buildPriceTag(),

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

  // -----------------------------------------------------------
  // BACKGROUND GRADIENT
  // -----------------------------------------------------------
  BoxDecoration _buildBackgroundGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF86D9F6), Color(0xFF0988BF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // -----------------------------------------------------------
  // HEADER
  // -----------------------------------------------------------
  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(Icons.workspace_premium, size: 90, color: Colors.white),
        const SizedBox(height: 10),
        Text(
          _getTitle(purchase.productId),
          style: const TextStyle(
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

  // -----------------------------------------------------------
  // FİYAT ROZETİ — Manuel fiyat
  // -----------------------------------------------------------
  Widget _buildPriceTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _getPriceText(purchase.productId),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// *** Manuel fiyat seçimi — format: TRY 40.00 ***
  String _getPriceText(String productId) {
    switch (productId) {
      case 'weekly_premium':
        return "TRY 40.00";
      case 'monthly_premium':
        return "TRY 100.00";
      case 'yearly_premium':
        return "TRY 600.00";
      default:
        return "TRY —";
    }
  }

  // -----------------------------------------------------------
  // INFO CARD
  // -----------------------------------------------------------
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
          _infoBulletCheck("Reklamsız uygulama kullanımı"),
          const SizedBox(height: 15),
          _infoBulletCheck("Bütün destelere sınırsız erişim"),
          const SizedBox(height: 25),
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

  Widget _buildGooglePlayLink() {
    return GestureDetector(
      onTap: _openGooglePlaySubscriptions,
      child: Row(
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

  // -----------------------------------------------------------
  // Title
  // -----------------------------------------------------------
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

  // -----------------------------------------------------------
  // Renew Text
  // -----------------------------------------------------------
  String _getRenewText(String productId) {
    switch (productId) {
      case 'weekly_premium':
        return "Üyeliğiniz iptal edilmediği sürece haftalık olarak yenilenir.";
      case 'monthly_premium':
        return "Üyeliğiniz iptal edilmediği sürece aylık olarak yenilenir.";
      case 'yearly_premium':
        return "Üyeliğiniz iptal edilmediği sürece yıllık olarak yenilenir.";
      default:
        return "Üyeliğiniz iptal edilmediği sürece yenilenmeye devam eder.";
    }
  }
}
