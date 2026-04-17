import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/screens/checkout_screen.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 HERO IMAGE SECTION
            _buildHeroImage(product),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CuratorDesign.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Authentic Kerala",
                          style: CuratorDesign.label(10, color: CuratorDesign.primary),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "4.8 (120 reviews)",
                            style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  Text(
                    product["name"] ?? "Unknown Product",
                    style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 28),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 12),

                  Text(
                    "₹${product["price"]}",
                    style: CuratorDesign.price(color: CuratorDesign.primary).copyWith(fontSize: 24),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    "Overview",
                    style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Experience the true essence of Kerala with our premium ${product["name"]}. Sourced directly from local farmers and artisans, this product represents the heritage and purity of God's Own Country.",
                    style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(height: 1.6),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 32),

                  // Quantity Selector
                  _buildQuantitySelector(context),

                  const SizedBox(height: 40),

                  // Seller Info (Subtle)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CuratorDesign.surfaceLowColor(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: CuratorDesign.primary.withValues(alpha: 0.2),
                          child: Icon(Icons.storefront_rounded, color: CuratorDesign.primary),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sold by", style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(fontSize: 12)),
                            Text("Kerala Artisans Co.", style: CuratorDesign.label(14, color: CuratorDesign.textPrimary(context))),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text("Visit Shop", style: CuratorDesign.label(12, color: CuratorDesign.primary)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 120), // Padding for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, product),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Bounceable(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        ),
      ),
      actions: [
        Bounceable(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
            ),
            child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(Map product) {
    return Hero(
      tag: 'prod-image-${product["id"]}',
      child: Container(
        height: 480,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
          child: CachedNetworkImage(
            imageUrl: product["imageUrl"] ?? "",
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported_rounded, size: 60, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Quantity",
          style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _qtyBtn(Icons.remove_rounded, () {
              if (qty > 1) setState(() => qty--);
            }),
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                qty.toString().padLeft(2, '0'),
                style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 20),
              ),
            ),
            _qtyBtn(Icons.add_rounded, () {
              setState(() => qty++);
            }),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: CuratorDesign.surfaceLowColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: CuratorDesign.primary.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: CuratorDesign.primary, size: 20),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, Map product) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: CuratorDesign.surfaceColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Bounceable(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read<CartProvider>().addItem(Map.from(product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Product added to cart"),
                    backgroundColor: CuratorDesign.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: CuratorDesign.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "Add to Cart",
                    style: CuratorDesign.label(14, color: CuratorDesign.primary, weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Bounceable(
              onTap: () {
                HapticFeedback.mediumImpact();
                final cartProvider = context.read<CartProvider>();
                cartProvider.addItem(Map.from(product));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(
                      cartItems: cartProvider.items,
                    ),
                  ),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: CuratorDesign.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CuratorDesign.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Buy Now",
                    style: CuratorDesign.label(14, color: Colors.white, weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}