import 'package:ben_kimim/data/app_purchase/model/product_model.dart';
import 'package:ben_kimim/presentation/premium/bloc/load_products_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/load_products_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/premium_status_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/purchase_cubit.dart';
import 'package:ben_kimim/presentation/premium/bloc/purchase_state.dart';
import 'package:ben_kimim/presentation/premium/bloc/selected_plan_cubit.dart';
import 'package:ben_kimim/presentation/premium/page/premium_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoadProductsCubit()..loadProducts(),
        ),
        BlocProvider(
          create: (context) => SelectedPlanCubit(),
        )
      ],
      child: BlocListener<PurchaseCubit, PurchaseState>(
          listener: (context, state) {},
          child: BlocBuilder<PremiumStatusCubit, PremiumStatusState>(
            builder: (context, state) {
              if (state is PremiumActive) {
                final productsState = context.read<LoadProductsCubit>().state;

                ProductModel? product;
                if (productsState is LoadProductsSuccess) {
                  product = productsState.products.firstWhere(
                    (p) => p.productId == state.purchase.productId,
                    orElse: () => productsState.products.first,
                  );
                }

                return PremiumInfoPage(
                  purchase: state.purchase,
                  product: product,
                );
              } else {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        children: const [
                          SizedBox(height: 20),
                          _HeaderSection(),
                          SizedBox(height: 20),
                          _FeaturesSection(),
                          SizedBox(height: 30),
                          Expanded(child: _PlansSection()),
                          SizedBox(height: 16),
                          _StartButton(),
                          SizedBox(height: 16),
                          _BottomLinks(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}

/* ---------------- HEADER ---------------- */

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.workspace_premium, color: Colors.orange, size: 80),
        SizedBox(height: 10),
        Text(
          "PREMİUM PLAN",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
        SizedBox(height: 10),
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                )),
            Text(price,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}

/* ---------------- BUTTON ---------------- */

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        final isLoading = state is PurchaseInProgress;

        return ElevatedButton(
          onPressed: isLoading
              ? null // Satın alma sürecindeyse tıklamayı iptal et
              : () {
                  // Satın alma işlemini başlat
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  "Şimdi Başla",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}

/* ---------------- FOOTER LINKS ---------------- */

class _BottomLinks extends StatelessWidget {
  const _BottomLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _PolicyLinks(),
        SizedBox(height: 8),
        _RestorePurchaseText(),
      ],
    );
  }
}

class _PolicyLinks extends StatelessWidget {
  const _PolicyLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _LinkText(text: "Gizlilik Politikası"),
        SizedBox(width: 20),
        _LinkText(text: "Kullanım Şartları"),
      ],
    );
  }
}

class _RestorePurchaseText extends StatelessWidget {
  const _RestorePurchaseText();

  @override
  Widget build(BuildContext context) {
    return const _LinkText(text: "Satın alımı geri yükle");
  }
}

class _LinkText extends StatelessWidget {
  final String text;

  const _LinkText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
