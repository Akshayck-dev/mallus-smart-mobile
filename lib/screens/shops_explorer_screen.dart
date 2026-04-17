import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/providers/product_provider.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:provider/provider.dart';

class ShopsExplorerScreen extends StatefulWidget {
  final VoidCallback? openDrawer;
  const ShopsExplorerScreen({super.key, this.openDrawer});

  @override
  State<ShopsExplorerScreen> createState() => _ShopsExplorerScreenState();
}

class _ShopsExplorerScreenState extends State<ShopsExplorerScreen> {
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.getByCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // 🏷️ HEADER
            _buildHeader(context),

            // 🔍 SEARCH & FILTERS
            _buildSearchSection(context),

            const SizedBox(height: 16),

            // 📂 VIEWPORT
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => productProvider.syncApiToFirebase(),
                color: CuratorDesign.primary,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Categories (Sliver)
                    SliverToBoxAdapter(
                      child: _buildCategoryList(context, productProvider),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Product Grid
                    if (productProvider.isLoading && products.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (products.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: Text("No products found in this category")),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductCard(
                              product: products[index],
                              index: index,
                            ),
                            childCount: products.length,
                          ),
                        ),
                      ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Bounceable(
            onTap: widget.openDrawer ?? () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CuratorDesign.surfaceLowColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.menu_rounded, color: CuratorDesign.primary, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "Kerala Shop",
            style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 20),
          ),
          const Spacer(),
          Bounceable(
            onTap: () {},
            child: Hero(
              tag: 'shop-filter-icon',
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CuratorDesign.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.tune_rounded, color: CuratorDesign.primary, size: 20),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: CuratorDesign.cardDecoration(Theme.of(context).brightness == Brightness.dark).copyWith(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search Kerala artisans...",
            hintStyle: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: CuratorDesign.primary, size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
    );
  }

  Widget _buildCategoryList(BuildContext context, ProductProvider provider) {
    final categories = ["All", ...provider.categories.map((c) => c.name)];
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final catName = categories[index];
          final isSelected = _selectedCategory == catName;
          return Bounceable(
            onTap: () => setState(() => _selectedCategory = catName),
            child: AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? CuratorDesign.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? CuratorDesign.primary : CuratorDesign.primary.withValues(alpha: 0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                catName,
                style: CuratorDesign.label(
                  13, 
                  color: isSelected ? Colors.white : CuratorDesign.primary,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05, end: 0);
  }
}
