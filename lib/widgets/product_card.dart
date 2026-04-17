import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/data/models/product.dart';
import 'package:mallu_smart/screens/product_details_screen.dart';
import 'package:mallu_smart/providers/favorites_provider.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double? width;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
    this.index = 0,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isAdded = false;

  void _handleAddToCart(BuildContext context) {
    if (_isAdded) return;

    HapticFeedback.mediumImpact();
    context.read<CartProvider>().addItem(widget.product.toJson());

    setState(() => _isAdded = true);

    // Show SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Text('Product added to cart'),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: CuratorDesign.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Reset icon after delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isAdded = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) {
        final isFav = favorites.isFavorite(widget.product.id);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Bounceable(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProductDetailsScreen(product: widget.product.toJson()),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          child: Container(
            width: widget.width,
            clipBehavior: Clip.antiAlias,
            decoration: CuratorDesign.cardDecoration(isDark),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(CuratorDesign.radiusLarge),
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ProductDetailsScreen(product: widget.product.toJson()),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 125,
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'prod-image-${widget.product.id}',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(CuratorDesign.radiusLarge),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(milliseconds: 200),
                                placeholder: (context, url) => Container(
                                  color: CuratorDesign.surfaceLowColor(context),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          CuratorDesign.primary.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: CuratorDesign.surfaceLowColor(context),
                                  child: Icon(Icons.image_not_supported_outlined,
                                      color: CuratorDesign.textSecondary(context)),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Bounceable(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                favorites.toggleFavorite(widget.product.id);
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isFav
                                      ? Colors.red.withValues(alpha: 0.8)
                                      : Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 1),
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        height: 105,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CuratorDesign.heading(
                                      color: CuratorDesign.textPrimary(context))
                                  .copyWith(fontSize: 14, height: 1.2),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Kerala Authentic",
                              style: CuratorDesign.subtitle(
                                      color: CuratorDesign.textSecondary(context))
                                  .copyWith(fontSize: 12),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${widget.product.price.toStringAsFixed(0)}',
                                  style: CuratorDesign.price(
                                      color: CuratorDesign.primary),
                                ),
                                Bounceable(
                                  onTap: () => _handleAddToCart(context),
                                  scaleDown: 0.85, // 🔥 TACTILE SQUISH
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _isAdded ? 14 : 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: _isAdded
                                          ? const LinearGradient(colors: [
                                              Colors.orange,
                                              Colors.deepOrange
                                            ])
                                          : CuratorDesign.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        if (!_isAdded)
                                          BoxShadow(
                                            color: CuratorDesign.primary
                                                .withValues(alpha: 0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: AnimatedScale(
                                      scale: _isAdded ? 1.2 : 1.0, // 🔥 ICON POP
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        _isAdded
                                            ? Icons.done_rounded
                                            : Icons.add_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (widget.index * 50).ms, duration: 500.ms).slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOutQuart,
            );
      },
    );
  }
}
