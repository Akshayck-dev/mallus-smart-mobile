import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/providers/product_provider.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? openDrawer;
  const HomeScreen({super.key, this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      appBar: _buildAppBar(context),
      body: const HomeContent(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: Bounceable(
        onTap: openDrawer ?? () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CuratorDesign.surfaceLowColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.menu_rounded, color: CuratorDesign.primary, size: 22),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to",
            style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(fontSize: 12),
          ),
          Text(
            "Mallu Smart",
            style: CuratorDesign.heading(color: CuratorDesign.primary).copyWith(fontSize: 18),
          ),
        ],
      ),
      actions: [
        Bounceable(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CuratorDesign.surfaceLowColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, color: CuratorDesign.primary, size: 22),
          ),
        ),
      ],
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
    
    // 🧠 Initial fetch is now handled by the Provider's Firebase Sync engine
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ProductProvider>().syncApiToFirebase();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    
    // Category filter
    var featuredProducts = productProvider.getByCategory(_selectedCategory);
    
    // 🔍 Search filter (live query)
    if (_searchQuery.isNotEmpty) {
      featuredProducts = featuredProducts
          .where((p) => p.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () => productProvider.syncApiToFirebase(),
        color: CuratorDesign.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildSearchBar(context),
              const SizedBox(height: 24),
              _buildHeroBanner(context),
              const SizedBox(height: 28),

              // 📂 CATEGORIES SECTION
              _buildSectionHeader(context, "Explore Categories"),
              const SizedBox(height: 16),
              _buildCategoryList(context, productProvider),

              const SizedBox(height: 28),

              // 🛍️ FEATURED PRODUCTS GRID
              _buildSectionHeader(context, "Featured For You", showViewAll: true),
              const SizedBox(height: 16),
              
              if (productProvider.isLoading && productProvider.products.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (featuredProducts.isEmpty)
                _buildEmptyState(context)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    cacheExtent: 500, // 🔥 PRELOADS ITEMS FOR SMOOTHNESS
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    itemCount: featuredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: MediaQuery.of(context).size.width < 400 ? 0.62 : 0.72, // 🔥 ADAPTIVE RATIO
                    ),
                    itemBuilder: (context, index) => ProductCard(
                      product: featuredProducts[index],
                      index: index,
                    ),
                  ),
                ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 60,
                color: CuratorDesign.textSecondary(context)),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? "No results for \"$_searchQuery\""
                  : "No products in this category",
              style: CuratorDesign.subtitle(
                  color: CuratorDesign.textSecondary(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 54,
      decoration: CuratorDesign.cardDecoration(
              Theme.of(context).brightness == Brightness.dark)
          .copyWith(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search local products...",
          hintStyle: CuratorDesign.subtitle(
                  color: CuratorDesign.textSecondary(context))
              .copyWith(fontSize: 14),
          prefixIcon:
              Icon(Icons.search_rounded, color: CuratorDesign.primary, size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: CuratorDesign.textSecondary(context), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = "");
                  },
                )
              : Icon(Icons.tune_rounded,
                  color: CuratorDesign.primary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CuratorDesign.radiusLarge),
        gradient: CuratorDesign.cinematicGradient,
        boxShadow: [
          BoxShadow(
            color: CuratorDesign.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.spa_rounded,
              size: 200,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "New Arrivals",
                    style: CuratorDesign.label(10, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Discover the Soul\nof Kerala",
                  style: CuratorDesign.title(color: Colors.white).copyWith(fontSize: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  "Authentic & Homemade",
                  style: CuratorDesign.subtitle(color: Colors.white.withValues(alpha: 0.8)).copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildSectionHeader(BuildContext context, String title, {bool showViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context)),
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {},
            child: Text(
              "View All",
              style: CuratorDesign.label(14, color: CuratorDesign.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryList(BuildContext context, ProductProvider provider) {
    final chipCategories = ["All", ...provider.categories.map((c) => c.name)];
    
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chipCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final catName = chipCategories[index];
          final isSelected = _selectedCategory == catName;
          return Bounceable(
            onTap: () => setState(() => _selectedCategory = catName),
            child: AnimatedContainer(
              duration: 300.ms,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? CuratorDesign.primary : CuratorDesign.surfaceLowColor(context),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isSelected ? CuratorDesign.primary : CuratorDesign.primary.withValues(alpha: 0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                catName,
                style: CuratorDesign.label(
                  14, 
                  color: isSelected ? Colors.white : CuratorDesign.primary,
                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1, end: 0);
  }
}