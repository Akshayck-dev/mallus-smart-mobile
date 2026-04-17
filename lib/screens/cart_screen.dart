import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/data/models/cart_item.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:mallu_smart/screens/checkout_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? openDrawer;
  const CartScreen({super.key, this.openDrawer});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      appBar: _buildAppBar(context, cart),
      body: cart.items.isEmpty
          ? _buildEmptyState(context)
          : _buildCartList(context, cart),
      bottomNavigationBar:
          cart.items.isEmpty ? null : _buildCheckoutBar(context, cart),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CartProvider cart) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Bounceable(
        onTap: openDrawer ?? () {},
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CuratorDesign.surfaceLowColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.menu_rounded, color: CuratorDesign.primary, size: 20),
        ),
      ),
      title: Text(
        "Shopping Cart",
        style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context))
            .copyWith(fontSize: 20),
      ),
      actions: [
        if (cart.items.isNotEmpty)
          TextButton(
            onPressed: () => cart.clearCart(),
            child:
                Text("Clear", style: CuratorDesign.label(14, color: Colors.redAccent)),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: CuratorDesign.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_basket_outlined,
                size: 80, color: CuratorDesign.primary),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text(
            "Your basket is empty",
            style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 12),
          Text(
            "Looks like you haven't added\nany items yet.",
            textAlign: TextAlign.center,
            style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 40),
          Bounceable(
            onTap: () {
              // Usually in persistent_bottom_nav_bar, we want to switch back to index 0
              // For now, we just pop if we can, otherwise do nothing
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: CuratorDesign.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Start Shopping",
                style: CuratorDesign.label(16, color: Colors.white),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartProvider cart) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildCartItem(context, cart, cart.items[index], index);
      },
    );
  }

  Widget _buildCartItem(
      BuildContext context, CartProvider cart, CartItem item, int index) {
    final imageUrl = item.product["imageUrl"] ?? "";
    final name = item.product["name"] ?? "Product";
    final price = (item.product["price"] as num).toDouble();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: CuratorDesign.cardDecoration(
          Theme.of(context).brightness == Brightness.dark),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: CuratorDesign.surfaceLowColor(context)),
              errorWidget: (_, __, ___) => Container(
                color: CuratorDesign.surfaceLowColor(context),
                child: Icon(Icons.image_not_supported_outlined,
                    color: CuratorDesign.textSecondary(context)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CuratorDesign.heading(
                          color: CuratorDesign.textPrimary(context))
                      .copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "Authentic Kerala",
                  style: CuratorDesign.subtitle(
                          color: CuratorDesign.textSecondary(context))
                      .copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${price.toStringAsFixed(0)}",
                  style: CuratorDesign.price(color: CuratorDesign.primary)
                      .copyWith(fontSize: 16),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Column(
            children: [
              Bounceable(
                onTap: () => cart.increaseQty(index),
                child: _qtyBtn(Icons.add_rounded),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  item.quantity.toString().padLeft(2, '0'),
                  style: CuratorDesign.label(14,
                      color: CuratorDesign.textPrimary(context)),
                ),
              ),
              Bounceable(
                onTap: () => cart.decreaseQty(index),
                child: _qtyBtn(Icons.remove_rounded),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 500.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _qtyBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CuratorDesign.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: CuratorDesign.primary),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, 24 + MediaQuery.of(context).padding.bottom),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Amount",
                  style: CuratorDesign.subtitle(
                      color: CuratorDesign.textSecondary(context))),
              Text(
                "₹${cart.total.toStringAsFixed(0)}",
                style:
                    CuratorDesign.price(color: CuratorDesign.textPrimary(context))
                        .copyWith(fontSize: 22),
              ),
            ],
          ),
          const Spacer(),
          Bounceable(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(cartItems: cart.items),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
              child: Text(
                "Checkout",
                style:
                    CuratorDesign.label(16, color: Colors.white, weight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}