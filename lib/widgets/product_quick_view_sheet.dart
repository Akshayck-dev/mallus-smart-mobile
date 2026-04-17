import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/data/models/product.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/widgets/app_button.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class ProductQuickViewSheet extends StatelessWidget {
  final Product product;
  const ProductQuickViewSheet({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductQuickViewSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: CuratorDesign.surfaceColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: AspectRatio(
                          aspectRatio: 1.2,
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? Colors.white10 : const Color(0xFFF7F7F7),
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2, color: CuratorDesign.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: CuratorDesign.display(24, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category.toUpperCase(),
                                      style: CuratorDesign.label(10, weight: FontWeight.w700, color: CuratorDesign.textLight)
                                          .copyWith(letterSpacing: 2),
                                    ),
                                  ],
                                ),
                              ),
                               Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: CuratorDesign.display(20, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          Text(
                            product.description,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: CuratorDesign.body(14, color: CuratorDesign.textLight).copyWith(height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action
            Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: BoxDecoration(
                color: CuratorDesign.surfaceColor(context),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Add to collection',
                      height: 60,
                      colors: [isDark ? Colors.white : Colors.black],
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.read<CartProvider>().addItem(product.toJson());

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('RESERVED IN YOUR CART', style: CuratorDesign.label(10, weight: FontWeight.w900, color: isDark ? Colors.black : Colors.white)),
                            backgroundColor: isDark ? Colors.white : Colors.black,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.all(20),
                          ),
                        );
                      },
                      icon: Icon(Icons.shopping_bag_outlined, size: 20, color: isDark ? Colors.black : Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _CircleAction(
                    icon: Icons.arrow_forward_rounded,
                    onTap: () => Navigator.pop(context),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _CircleAction({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 24),
      ),
    );
  }
}
