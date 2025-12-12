// Boşlukları dikeyde %30 azaltılmış tam güncellenmiş kod
// NOT: Sadece dikey boşluk (height, vertical padding/margin) azaltıldı. Başka hiçbir şeye dokunulmadı.

import 'package:ben_kimim/common/widget/alert/secret_dialog.dart';
import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:ben_kimim/data/app_purchase/model/purchase_model.dart';
import 'package:ben_kimim/presentation/premium/bloc/load_products_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/load_products_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_counter_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/purchase_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/purchase_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/selected_plan_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/unlock_premium.dart';
import 'package:ben_kimim/presentation/premium/page/premium_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoadProductsCubit()..loadProducts()),
        BlocProvider(create: (context) => SelectedPlanCubit()),
        BlocProvider(create: (context) => PremiumCounterCubit()),
      ],
      child: BlocBuilder<PremiumStatusCubit, PremiumStatusState>(
        builder: (context, state) {
          // unlock durumunu oku
          final unlock = context.watch<UnlockPremiumCubit>().state;

          // Eğer gerçek premium ya da unlock (test) aktifse PremiumInfoPage'e git
          if (state is PremiumActive || unlock == true) {
            final productsState = context.read<LoadProductsCubit>().state;

            ProductModel? product;
            PurchaseModel? purchase;

            if (state is PremiumActive) {
              // Gerçek premium kullanıcı
              purchase = state.purchase;

              if (productsState is LoadProductsSuccess &&
                  productsState.products.isNotEmpty) {
                product = productsState.products.firstWhere(
                  (p) => p.productId == state.purchase.productId,
                  orElse: () => productsState.products
                      .first, // kesinlikle ProductModel döner çünkü liste dolu
                );
              } else {
                // Ürün listesi henüz yüklenmemiş veya boşsa, null bırak
                product = null;
              }
            } else {
              // Google test modu → sahte ürün ve sahte satın alma gönder
              product = ProductModel(
                productId: "test_premium",
                title: "Test Premium",
                description: "Google Play inceleme modu için test ürünü",
                price: "₺0,00",
                rawPrice: 0.0,
              );

              purchase = PurchaseModel(
                productId: "test_premium",
                isActive: true,
                purchaseDate: DateTime.now(),
                isSubscription: true,
              );
            }

            return PremiumInfoPage(
              purchase: purchase,
              product: product,
            );
          } else {
            // premium değilse normal sayfayı göster
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 11), // 16 → 11 (%30 azaltıldı)
                  child: Column(
                    children: const [
                      SizedBox(height: 13), // 18 → 13
                      _HeaderSection(),
                      SizedBox(height: 13), // 18 → 13
                      _FeaturesSection(),
                      SizedBox(height: 17), // 24 → 17
                      Expanded(child: _PlansSection()),
                      SizedBox(height: 10), // 14 → 10
                      _PaymentInfoText(),
                      SizedBox(height: 7), // 10 → 7
                      _StartButton(),
                      SizedBox(height: 10), // 14 → 10
                      _BottomLinks(),
                      SizedBox(height: 12), // 18 → 12
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/* ---------------- HEADER ---------------- */

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            final counterCubit = context.read<PremiumCounterCubit>();
            counterCubit.increment();

            if (counterCubit.state >= 8) {
              counterCubit.reset(); // tekrar tıklayabilsin
              SecretDialog.showSecretDialog(context);
            }
          },
          icon: Icon(Icons.workspace_premium, color: Colors.orange, size: 80),
        ),
        SizedBox(height: 6), // 8 → 6
        Text(
          "VIP ÜYELİKLER",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/* ---------------- FEATURES ---------------- */

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _FeatureRow(icon: Icons.style, text: "Tüm desteleri oyna"),
        SizedBox(height: 6), // 8 → 6
        _FeatureRow(icon: Icons.block, text: "Tüm reklamları kaldır"),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.black, size: 24),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 18)),
        const SizedBox(width: 10),
        const Icon(Icons.check_circle, color: Colors.green, size: 24),
      ],
    );
  }
}

/* ---------------- PLANS ---------------- */

class _PlansSection extends StatelessWidget {
  const _PlansSection();
  String _getTitle(String productId) {
    switch (productId) {
      case 'weekly_premium':
        return 'Haftalık Üyelik';
      case 'monthly_premium':
        return 'Aylık Üyelik';
      case 'yearly_premium':
        return 'Yıllık Üyelik';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadProductsCubit, LoadProductsState>(
      builder: (context, state) {
        if (state is LoadProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadProductsFailure) {
          return Center(child: Text("Hata: ${state.message}"));
        }
        if (state is LoadProductsSuccess) {
          final products = state.products;
          final selectedProductId = context.watch<SelectedPlanCubit>().state;
          final isPurchasing =
              context.watch<PurchaseCubit>().state is PurchaseInProgress;

          return ListView(
            children: [
              PlanTile(
                title: _getTitle('weekly_premium'),
                price: products
                    .firstWhere((p) => p.productId == 'weekly_premium')
                    .price,
                selected: selectedProductId == 'weekly_premium',
                onTap: () {
                  if (!isPurchasing) {
                    context
                        .read<SelectedPlanCubit>()
                        .selectPlan('weekly_premium');
                  }
                },
              ),
              PlanTile(
                title: _getTitle('monthly_premium'),
                price: products
                    .firstWhere((p) => p.productId == 'monthly_premium')
                    .price,
                selected: selectedProductId == 'monthly_premium',
                onTap: () {
                  if (!isPurchasing) {
                    context
                        .read<SelectedPlanCubit>()
                        .selectPlan('monthly_premium');
                  }
                },
              ),
              PlanTile(
                title: _getTitle('yearly_premium'),
                price: products
                    .firstWhere((p) => p.productId == 'yearly_premium')
                    .price,
                selected: selectedProductId == 'yearly_premium',
                onTap: () {
                  if (!isPurchasing) {
                    context
                        .read<SelectedPlanCubit>()
                        .selectPlan('yearly_premium');
                  }
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class PlanTile extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  const PlanTile({
    super.key,
    required this.title,
    required this.price,
    this.selected = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), // 12 → 8
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300, width: 2),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500),
          ),
          Text(price,
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

/* ---------------- PAYMENT INFO TEXT ---------------- */

class _PaymentInfoText extends StatelessWidget {
  const _PaymentInfoText();
  @override
  Widget build(BuildContext context) {
    return const Text(
      "  Satın alma onayından sonra ödeme hesabınızdan tahsil edilir. Abonelik, dönem sonunda otomatik olarak yenilenir; yenilemeyi istediğiniz zaman iptal edebilirsiniz.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black87, fontSize: 14),
    );
  }
}

/* ---------------- START BUTTON ---------------- */

class _StartButton extends StatefulWidget {
  const _StartButton();
  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.95,
        upperBound: 1.05)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        final isLoading = state is PurchaseInProgress;
        return AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            return Transform.scale(
              scale: isLoading ? 1.0 : _pulse.value,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.60,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final selectedProductId =
                              context.read<SelectedPlanCubit>().state;
                          if (selectedProductId != null) {
                            context
                                .read<PurchaseCubit>()
                                .purchaseProduct(selectedProductId);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      : const Text("Şimdi Başla",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/* ---------------- FOOTER ---------------- */

class _BottomLinks extends StatelessWidget {
  const _BottomLinks();
  @override
  Widget build(BuildContext context) {
    return Column(children: const [_PolicyLinks()]);
  }
}

class _PolicyLinks extends StatelessWidget {
  const _PolicyLinks();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
      _LinkText(
        text: "Gizlilik Politikası",
        url:
            "https://docs.google.com/document/d/1G6uFDjzhF0GtXdVZeABFYKrQEsTZ-ZRhXvSzqsLGJqY/edit?usp=sharing",
      ),
      SizedBox(width: 20),
      _LinkText(
        text: "Kullanım Şartları",
        url:
            "https://docs.google.com/document/d/1IYbsnY3x3O1CeM2XHA_nRe97OuJXK_QP9up2aGOw_c0/edit?usp=sharing",
      ),
    ]);
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final String url;
  const _LinkText({required this.text, required this.url});
  Future<void> _openLink() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openLink,
      child: Text(text,
          style: const TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline)),
    );
  }
}
