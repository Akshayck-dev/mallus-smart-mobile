import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/models/product.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/screens/product_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/favorites_provider.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mallu_smart/widgets/confetti_celebration.dart';

import 'package:mallu_smart/widgets/shimmer_loader.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, child) {
        final isFav = favorites.isFavorite(product.id);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (context, animation, secondaryAnimation) => 
                  ProductDetailsScreen(product: product),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: CuratorDesign.cardDecoration(isDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'prod-${product.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerLoader(
                              width: double.infinity, 
                              height: double.infinity,
                              borderRadius: 0,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFF3F4F6),
                              child: const Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => favorites.toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                            size: 16, 
                            color: isFav ? Colors.redAccent : CuratorDesign.textDark
                          ).animate(target: isFav ? 1 : 0)
                           .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 200.ms, curve: Curves.easeOutBack)
                           .then()
                           .scale(begin: const Offset(1.3, 1.3), end: const Offset(1, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  product.name,
                  style: CuratorDesign.display(14, color: Theme.of(context).textTheme.bodyLarge?.color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.category.toUpperCase(),
                  style: CuratorDesign.label(8, color: CuratorDesign.textLight).copyWith(letterSpacing: 1),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product.price.toInt()}',
                          style: CuratorDesign.display(16, color: CuratorDesign.primaryOrange),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        context.read<CartProvider>().addToCart(product);
                        showConfetti(context);
                        
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: CuratorDesign.textDark,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
                                const SizedBox(width: 12),
                                Text(
                                  'Added to your selection',
                                  style: CuratorDesign.label(12, color: Colors.white),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: CuratorDesign.textDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'ADD',
                              style: CuratorDesign.label(10, color: Colors.white).copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate()
           .scale(begin: const Offset(0.9, 0.9), delay: 100.ms, duration: 600.ms, curve: Curves.easeOutQuart)
           .fadeIn(duration: 600.ms),
        );
      }
    );
  }
}
