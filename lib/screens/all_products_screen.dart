import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:mallu_smart/data/sample_data.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:mallu_smart/widgets/premium_loader.dart';
import 'package:mallu_smart/services/product_service.dart';
import 'package:mallu_smart/models/product.dart';

import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/language_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mallu_smart/widgets/product_skeleton.dart';
import 'package:mallu_smart/widgets/magnetic_wrapper.dart';

import 'package:mallu_smart/widgets/category_selector.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Paging State
  List<Product> _products = [];
  int _currentPage = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  static const int _pageSize = 8; // Increased for better fill

  String selectedCategory = 'ALL';
  String searchQuery = '';
  List<String> _recentSearches = [];
  
  final List<String> categories = [
    'ALL',
    'FRUITS',
    'BAKERY',
    'GROCERIES',
    'FASHION',
    'ACCESSORIES'
  ];

  @override
  void initState() {
    super.initState();
    _fetchInitialPage();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoadingMore && _hasMore) {
          _fetchNextPage();
        }
      }
    });

    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 5) _recentSearches.removeLast();
    await prefs.setStringList('recent_searches', _recentSearches);
    setState(() {});
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialPage() async {
    setState(() {
      _isLoading = true;
      _products = [];
      _currentPage = 0;
      _hasMore = true;
    });

    try {
      final items = await ProductService.fetchProductsPaged(
        page: 0, 
        limit: _pageSize,
        category: selectedCategory,
      );
      
      if (mounted) {
        setState(() {
          _products = items;
          _isLoading = false;
          _hasMore = items.length >= _pageSize;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNextPage() async {
    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final items = await ProductService.fetchProductsPaged(
        page: nextPage, 
        limit: _pageSize,
        category: selectedCategory,
      );

      if (mounted) {
        setState(() {
          _products.addAll(items);
          _currentPage = nextPage;
          _isLoadingMore = false;
          _hasMore = items.isNotEmpty && items.length >= _pageSize;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _onCategoryChanged(String cat) {
    if (selectedCategory == cat) return;
    HapticFeedback.mediumImpact();
    setState(() => selectedCategory = cat);
    _fetchInitialPage();
  }

  @override
  Widget build(BuildContext context) {
    // Local search filter for current paged products
    final filteredProducts = _products.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern Floating Search Bar
          SliverAppBar(
            toolbarHeight: 0,
            expandedHeight: 80,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: CuratorDesign.surface.withOpacity(0.9),
            flexibleSpace: FlexibleSpaceBar(background: Container(color: CuratorDesign.surface)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchQuery = v),
                        onSubmitted: (v) => _saveSearch(v),
                        style: CuratorDesign.body(14, color: Theme.of(context).textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          hintText: context.read<LanguageProvider>().translate('search_hint'),
                          hintStyle: CuratorDesign.body(14, color: Colors.black26),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: CuratorDesign.textLight),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutQuart),
                ),
              ),
            ),
          ),

          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => Text(
                      '${_getGreeting().toUpperCase()}, ${lang.translate('explore')}', 
                      style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 2.5)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => Text(
                      lang.translate('curated_collections'), 
                      style: CuratorDesign.display(32, color: Theme.of(context).textTheme.bodyLarge?.color).copyWith(height: 1.1)
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05),

          // Categories Horizontal List
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: CategorySelector(
                categories: categories,
                onCategorySelected: _onCategoryChanged,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.05),

          // Product Grid
          _isLoading 
          ? SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.58,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ProductSkeleton(),
                  childCount: 6,
                ),
              ),
            )
          : filteredProducts.isEmpty && !_isLoading
          ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded, size: 64, color: CuratorDesign.grey),
                    const SizedBox(height: 16),
                    Text('No items found', style: CuratorDesign.body(14, color: CuratorDesign.textLight)),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.58,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final isEven = index % 2 == 0;
                    return ProductCard(product: filteredProducts[index])
                        .animate()
                        .fadeIn(duration: 600.ms, delay: (index * 50).ms)
                        .slideX(begin: isEven ? -0.2 : 0.2, curve: Curves.easeOutQuart);
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),

          // Loading More Indicator
          if (_isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: const PremiumCuratorLoader(size: 32),
                  ).animate().scale().fadeIn(),
                ),
              ),
            )
          else 
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.heavyImpact();
          final Uri waUrl = Uri.parse('https://wa.me/911234567890?text=Hi%20Mallu%20Mart!%20I%20have%20a%20question.');
          launchUrl(waUrl, mode: LaunchMode.externalApplication);
        },
        backgroundColor: const Color(0xFF25D366), // WhatsApp Green
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ).animate().scale(delay: 1.seconds, duration: 800.ms, curve: Curves.easeOutBack),
    );
  }
}
