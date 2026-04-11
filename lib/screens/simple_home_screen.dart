import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:mallu_smart/widgets/category_selector.dart';
import 'package:mallu_smart/data/sample_data.dart';
import 'package:mallu_smart/models/product.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/language_provider.dart';

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  String _selectedCategory = 'ALL';
  String _searchQuery = '';

  List<Product> get _filteredProducts {
    return allProducts.where((p) {
      final matchesCategory = _selectedCategory == 'ALL' || p.category.toUpperCase() == _selectedCategory;
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Minimalist AppBar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: CuratorDesign.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                'MALLU SMART',
                style: CuratorDesign.display(16, color: CuratorDesign.textDark).copyWith(letterSpacing: 3),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: CuratorDesign.textDark),
                onPressed: () {
                  // Show search bottom sheet or navigation
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ESSENTIALS',
                    style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 2),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Freshly Selected\nFor You',
                    style: CuratorDesign.display(28, color: CuratorDesign.textDark).copyWith(height: 1.1),
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),
                ],
              ),
            ),
          ),

          // Search Bar (Simple Style)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: CuratorDesign.body(14, color: Colors.black26),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.black26),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),

          // Category Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CategorySelector(
                categories: const ['ALL', 'FRUITS', 'BAKERY', 'GROCERIES', 'FASHION'],
                onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),

          // Product List Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Divider(color: Colors.black12),
            ),
          ),

          // Simple Product Grid (no parallax)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(product: product)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: (index * 50).ms)
                      .slideY(begin: 0.05);
                },
                childCount: _filteredProducts.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
