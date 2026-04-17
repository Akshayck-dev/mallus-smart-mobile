import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/favorites_provider.dart';
import 'package:mallu_smart/data/sample_data.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final favoriteProducts = allProducts
        .where((p) => favoritesProvider.isFavorite(p.id))
        .toList();

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildBoutiqueHeader(context, isDark),
            Expanded(
              child: favoriteProducts.isEmpty
                  ? _buildEmptyState(isDark)
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: favoriteProducts[index])
                            .animate(delay: (index * 100).ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.1);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoutiqueHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleAction(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            isDark: isDark,
          ),
          Text(
            'My Selection',
            style: CuratorDesign.label(16, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 32,
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2000.ms),
            const SizedBox(height: 32),
            Text(
              'EMPTY COLLECTION', 
              style: CuratorDesign.label(10, weight: FontWeight.w900, color: CuratorDesign.textLight)
                  .copyWith(letterSpacing: 2)
            ),
            const SizedBox(height: 12),
            Text(
              'Curate your favorites and they will appear here.',
              textAlign: TextAlign.center,
              style: CuratorDesign.body(14, color: CuratorDesign.textLight).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF0F0F0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 18),
      ),
    );
  }
}
