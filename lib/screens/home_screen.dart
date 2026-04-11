import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:mallu_smart/widgets/search_bar_sliver.dart';
import 'package:mallu_smart/widgets/category_selector.dart';
import 'package:mallu_smart/data/sample_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // Data refresh logic would go here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: CuratorDesign.primaryOrange,
        backgroundColor: Colors.white,
        displacement: 40,
        strokeWidth: 3,
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            const _PremiumAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroGreeting(),
                  const SizedBox(height: 24),
                  _ParallaxFeaturedBanner(scrollController: _scrollController),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            const SearchBarSliver(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  CategorySelector(
                    categories: const ['All', 'Fruits', 'Bakery', 'Groceries', 'Meat', 'Fashion'],
                    onCategorySelected: (category) {
                      // Filter logic would go here
                    },
                  ),
                  const SizedBox(height: 32),
                  const _SectionHeader(title: 'NEW ARRIVALS', actionText: 'SEE ALL'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const _ProductGrid(),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _PremiumAppBar extends StatelessWidget {
  const _PremiumAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: CuratorDesign.textDark),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
        title: Text(
          "MALLU'S MART",
          style: CuratorDesign.display(18, color: CuratorDesign.textDark).copyWith(letterSpacing: 2),
        ),
        background: Container(color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: CuratorDesign.textDark),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 2,
                color: CuratorDesign.primaryOrange,
              ),
              const SizedBox(width: 8),
              Text(
                'CURATED FRESHNESS',
                style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: CuratorDesign.display(32, color: CuratorDesign.textDark),
              children: const [
                TextSpan(text: 'Taste the\n'),
                TextSpan(
                  text: 'Premium Life',
                  style: TextStyle(color: CuratorDesign.primaryOrange, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _ParallaxFeaturedBanner extends StatelessWidget {
  final ScrollController scrollController;
  
  const _ParallaxFeaturedBanner({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: scrollController,
                builder: (context, child) {
                  double parallaxOffset = 0;
                  if (scrollController.hasClients) {
                    parallaxOffset = scrollController.offset * 0.2;
                  }
                  return Positioned.fill(
                    top: -parallaxOffset, 
                    bottom: -50,
                    child: child!,
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=800&auto=format&fit=crop',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: CuratorDesign.primaryOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('WEEKEND DEAL', style: CuratorDesign.label(10, color: Colors.white)),
                    ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
                    const SizedBox(height: 12),
                    Text('Organic\nHarvest Week', 
                      style: CuratorDesign.display(24, color: Colors.white).copyWith(height: 1.1)
                    ),
                    const SizedBox(height: 8),
                    Text('Save 20% on all produce', 
                      style: CuratorDesign.body(12, color: Colors.white70)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;

  const _SectionHeader({required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: CuratorDesign.display(18)),
          Text(actionText, style: CuratorDesign.label(12, color: CuratorDesign.primaryOrange)),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(product: allProducts[index])
              .animate(delay: (100 * index).ms)
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.1, curve: Curves.easeOut),
          childCount: allProducts.length,
        ),
      ),
    );
  }
}
