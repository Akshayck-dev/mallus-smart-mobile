import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/design_system.dart';
import '../providers/cart_provider.dart';
import '../widgets/curator_app_bar.dart';
import 'checkout_screen.dart';
import '../widgets/main_navigation.dart';
import '../widgets/deep_heat_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      appBar: const CuratorAppBar(title: 'YOUR CART'),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 180,
                    child: Lottie.network(
                      'https://lottie.host/80dc0e6e-21ef-41cc-8df1-e87f58b06606/sD0i9oI5fB.json',
                      errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.shopping_bag_outlined, size: 80, color: CuratorDesign.grey),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms),
                  const SizedBox(height: 24),
                  Text('YOUR BAG IS EMPTY',
                      style: CuratorDesign.label(14, color: CuratorDesign.textLight).copyWith(letterSpacing: 3)),
                  const SizedBox(height: 12),
                  Text('Looks like you haven\'t added\nanything to your bag yet.',
                      textAlign: TextAlign.center,
                      style: CuratorDesign.body(14, color: Colors.black26)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: DeepHeatButton(
                      text: 'START SHOPPING',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        final navState = context.findAncestorStateOfType<MainNavigationState>();
                        navState?.setTabIndex(1);
                      },
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 220),
                  itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Dismissible(
                        key: Key(item.product.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          HapticFeedback.mediumImpact();
                          cart.removeFromCart(item.product.id);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: item.product.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(width: 90, height: 90, color: CuratorDesign.surface),
                                    errorWidget: (context, url, error) => Container(
                                      width: 90, height: 90, color: CuratorDesign.surface, 
                                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.black12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.name,
                                          style: CuratorDesign.display(16, color: CuratorDesign.textDark)),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: CuratorDesign.surface,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text('${item.quantity} UNITS',
                                            style: CuratorDesign.label(10, color: CuratorDesign.textLight)),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                          '₹${(item.product.price * item.quantity).toInt()}',
                                          style: CuratorDesign.display(16, color: CuratorDesign.primaryOrange)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    cart.removeFromCart(item.product.id);
                                  },
                                  icon: const Icon(Icons.close_rounded, size: 20, color: Colors.black12),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05),
                      );
                    },
                  ),
                // Fixed Bottom Summary Glassmorphic Section
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 110),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          border: const Border(top: BorderSide(color: Colors.black12, width: 0.5)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL ESTIMATE', style: CuratorDesign.label(12, color: CuratorDesign.textLight)),
                                Text('₹${cart.total.toInt()}',
                                    style: CuratorDesign.display(28, color: CuratorDesign.textDark)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            DeepHeatButton(
                              text: 'PROCEED TO CHECKOUT',
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CheckoutScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutQuart),
                ),
              ],
            ),
    );
  }
}
