import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      resizeToAvoidBottomInset: true,
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

  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _currentPage = 0;
  Timer? _bannerTimer;

  final List<Map<String, String>> _banners = [
    {
      "title": "Authentic Kerala Spices",
      "subtitle": "Fresh from the spice gardens of Idukki.",
      "image": "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=1000&auto=format&fit=crop",
      "tag": "FRESH"
    },
    {
      "title": "Homemade Goodness",
      "subtitle": "Traditional recipes, made with love.",
      "image": "https://images.unsplash.com/photo-1593693397690-362cb9666fc2?q=80&w=1000&auto=format&fit=crop",
      "tag": "TRADITIONAL"
    },
    {
      "title": "Wellness from Nature",
      "subtitle": "Ayurvedic products for a better life.",
      "image": "https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?q=80&w=1000&auto=format&fit=crop",
      "tag": "WELLNESS"
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
    
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    
    final allProducts = productProvider.products;
    final searchResults = _searchQuery.isEmpty 
        ? [] 
        : allProducts.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();

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

              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildSectionHeader(context, "Search Results for \"$_searchQuery\""),
                const SizedBox(height: 16),
                if (searchResults.isEmpty)
                  _buildEmptyState(context)
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) => ProductCard(
                      product: searchResults[index],
                      index: index,
                    ),
                  ),
              ] else ...[
                const SizedBox(height: 8),

                if (productProvider.isLoading && allProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (allProducts.isEmpty)
                  _buildEmptyState(context)
                else ...[
                  // ⭐ FEATURED SECTION
                  _buildSectionHeader(context, "Featured For You", showViewAll: true),
                  const SizedBox(height: 16),
                  _buildHorizontalProductList(
                    context, 
                    allProducts.where((p) => p.stars >= 4.5).take(6).toList()
                  ),

                  const SizedBox(height: 32),

                  // 🆕 NEW ARRIVALS
                  _buildSectionHeader(context, "New Arrivals", showViewAll: true),
                  const SizedBox(height: 16),
                  _buildHorizontalProductList(
                    context, 
                    allProducts.reversed.take(6).toList()
                  ),

                  const SizedBox(height: 32),

                  // 🔥 MOST POPULAR
                  _buildSectionHeader(context, "Most Popular", showViewAll: true),
                  const SizedBox(height: 16),
                  _buildHorizontalProductList(
                    context, 
                    allProducts.where((p) => p.reviewCount > 10).take(6).toList()
                  ),
                ],
              ],

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList(BuildContext context, List<dynamic> products) {
    if (products.isEmpty) {
      // Fallback if filtered list is empty
      products = context.read<ProductProvider>().products.take(6).toList();
    }
    
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        clipBehavior: Clip.none,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 180,
            child: ProductCard(
              product: products[index],
              index: index,
            ),
          );
        },
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
                  : "No products found",
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
    ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CuratorDesign.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: CuratorDesign.primary.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // 🖼️ BACKGROUND IMAGE
                    Positioned.fill(
                      child: Image.network(
                        banner['image']!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: CuratorDesign.surfaceLowColor(context),
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          );
                        },
                      ),
                    ),
                    
                    // 🎞️ GRADIENT OVERLAY
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.black.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 📝 CONTENT
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: CuratorDesign.primary.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              banner['tag']!,
                              style: CuratorDesign.label(10, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            banner['title']!,
                            style: CuratorDesign.title(color: Colors.white).copyWith(fontSize: 24, height: 1.1),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle']!,
                            style: CuratorDesign.subtitle(color: Colors.white.withValues(alpha: 0.86)).copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // ⚪️ INDICATORS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? CuratorDesign.primary : CuratorDesign.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
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


}