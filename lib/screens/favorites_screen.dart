import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/favorites_provider.dart';
import 'package:mallu_smart/data/sample_data.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoriteProducts = allProducts
        .where((p) => favoritesProvider.isFavorite(p.id))
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('MY SELECTION', 
          style: CuratorDesign.label(12, color: Theme.of(context).textTheme.bodyLarge?.color)
              .copyWith(letterSpacing: 4)
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoriteProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, 
                    size: 64, 
                    color: CuratorDesign.primaryOrange.withValues(alpha: 0.2)
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                   .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2000.ms),
                  const SizedBox(height: 24),
                  Text('Your curation is empty', 
                    style: CuratorDesign.display(18, color: CuratorDesign.textLight)
                  ),
                  const SizedBox(height: 8),
                  Text('Save items to find them here later.', 
                    style: CuratorDesign.body(14, color: CuratorDesign.textLight.withValues(alpha: 0.6))
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.58,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: favoriteProducts[index])
                    .animate(delay: (index * 100).ms)
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.1);
              },
            ),
    );
  }
}
