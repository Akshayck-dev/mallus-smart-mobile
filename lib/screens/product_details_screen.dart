import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/models/product.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/data/sample_data.dart';
import 'package:mallu_smart/widgets/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/widgets/confetti_celebration.dart';

import 'package:mallu_smart/widgets/shimmer_loader.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  int _quantity = 1;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Animation Values
    final double appBarOpacity = (_scrollOffset / 200).clamp(0, 1);
    final Color tintColor = CuratorDesign.categoryColor(widget.product.category);

    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15 * appBarOpacity,
              sigmaY: 15 * appBarOpacity,
            ),
            child: AppBar(
              backgroundColor: CuratorDesign.surface.withOpacity(appBarOpacity * 0.8),
              elevation: 0,
              centerTitle: true,
              title: Text(
                widget.product.name.toUpperCase(),
                style: CuratorDesign.label(12, color: CuratorDesign.textDark.withOpacity(appBarOpacity))
                    .copyWith(letterSpacing: 2),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1 - appBarOpacity),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: CuratorDesign.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1 - appBarOpacity),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border_rounded, size: 20, color: CuratorDesign.textDark),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedContainer(
        duration: 800.ms,
        color: _scrollOffset > 100 ? CuratorDesign.surface : tintColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parallax Hero Image
                  Stack(
                    children: [
                      SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Hero(
                          tag: 'prod-${widget.product.id}',
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(_scrollOffset * 0.0002)
                              ..scale(1.0 + (_scrollOffset > 0 ? _scrollOffset * 0.0005 : 0)),
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: widget.product.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShimmerLoader(
                                width: double.infinity, 
                                height: 500,
                                borderRadius: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.transparent,
                                Colors.transparent,
                                _scrollOffset > 100 ? CuratorDesign.surface : tintColor,
                              ],
                              stops: const [0.0, 0.2, 0.8, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PREMIUM SELECTION',
                                    style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange)
                                        .copyWith(letterSpacing: 3)),
                                const SizedBox(height: 8),
                                Text(widget.product.name, style: CuratorDesign.display(32)),
                              ],
                            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${widget.product.price.toInt()}',
                                  style: CuratorDesign.display(28, color: CuratorDesign.textDark)),
                              Text('PER UNIT', style: CuratorDesign.label(8, color: CuratorDesign.textLight)),
                            ],
                          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Interactive Tabs
                      Row(
                        children: [
                          _TabButton(
                            label: 'Description', 
                            isSelected: _selectedTabIndex == 0,
                            onTap: () => setState(() => _selectedTabIndex = 0),
                          ),
                          _TabButton(
                            label: 'Details', 
                            isSelected: _selectedTabIndex == 1,
                            onTap: () => setState(() => _selectedTabIndex = 1),
                          ),
                          _TabButton(
                            label: 'Shipping', 
                            isSelected: _selectedTabIndex == 2,
                            onTap: () => setState(() => _selectedTabIndex = 2),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Animated Tab Content
                      AnimatedSwitcher(
                        duration: 300.ms,
                        child: _buildTabContent(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      Row(
                        children: [
                          _FeatureCard(
                            icon: Icons.eco_rounded,
                            title: 'ORGANIC',
                            subtitle: 'Locally sourced fresh produce.',
                          ),
                          const SizedBox(width: 16),
                          _FeatureCard(
                            icon: Icons.timer_outlined,
                            title: 'EXPRESS',
                            subtitle: 'Delivered within 60 minutes.',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      Text('Recommended for you', style: CuratorDesign.display(20)),
                      const SizedBox(height: 20),
                      _buildRelatedProducts(),
                    ],
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1),
                ),
              ],
            ),
          ),
          
          // Floating Cart Controls (Glassmorphic)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
                  ),
                  child: Row(
                    children: [
                      // Quantity Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: CuratorDesign.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _QuantityBtn(
                              icon: Icons.remove_rounded, 
                              onTap: () {
                                if (_quantity > 1) {
                                  HapticFeedback.lightImpact();
                                  setState(() => _quantity--);
                                }
                              }
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('$_quantity', style: CuratorDesign.display(16)),
                            ),
                            _QuantityBtn(
                              icon: Icons.add_rounded, 
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _quantity++);
                              }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Add to Cart Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            context.read<CartProvider>().addToCart(widget.product, _quantity);
                            showConfetti(context);
                            
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: CuratorDesign.textDark,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(24).copyWith(bottom: 120),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Added $_quantity item${_quantity > 1 ? 's' : ''} to cart',
                                      style: CuratorDesign.label(12, color: Colors.white),
                                    ),
                                  ],
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: CuratorDesign.premiumGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: CuratorDesign.primaryOrange.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  'ADD TO CART', 
                                  style: CuratorDesign.label(12, color: Colors.white).copyWith(letterSpacing: 1, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().slideY(begin: 1.0, duration: 800.ms, curve: Curves.easeOutQuart),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts() {
    final related = allProducts.where((p) => p.category == widget.product.category && p.id != widget.product.id).toList();
    if (related.isEmpty) return const SizedBox();
    
    return SizedBox(
      height: 280,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: related.length,
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 16),
            child: ProductCard(product: related[index]),
          );
        },
      ),
    );
  }


  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Text(
          widget.product.description,
          key: const ValueKey(0),
          style: CuratorDesign.body(15, color: Colors.black.withValues(alpha: 0.6)).copyWith(height: 1.6),
        );
      case 1:
        return Column(
          key: const ValueKey(1),
          children: [
            _buildDetailRow('CATEGORY', widget.product.category),
            _buildDetailRow('ORIGIN', 'Local Farms, Kerala'),
            _buildDetailRow('WEIGHT', 'Approx 500g - 1kg'),
            _buildDetailRow('SHELF LIFE', '3-5 Days'),
          ],
        );
      case 2:
        return Text(
          'Enjoy express 60-minute delivery in selected zones. Standards shipping takes 24 hours. Free delivery on orders above ₹500.',
          key: const ValueKey(2),
          style: CuratorDesign.body(15, color: Colors.black.withValues(alpha: 0.6)).copyWith(height: 1.6),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CuratorDesign.label(10, color: CuratorDesign.textLight)),
          Text(value.toUpperCase(), style: CuratorDesign.display(12, color: CuratorDesign.textDark)),
        ],
      ),
    );
  }
}

class _QuantityBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 16, color: CuratorDesign.textDark),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CuratorDesign.textDark : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.1)),
        ),
        child: Text(
          label,
          style: CuratorDesign.label(12, color: isSelected ? Colors.white : CuratorDesign.textDark),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CuratorDesign.primaryOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: CuratorDesign.primaryOrange, size: 20),
            ),
            const SizedBox(height: 16),
            Text(title, style: CuratorDesign.label(10, color: CuratorDesign.textDark).copyWith(letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(subtitle, style: CuratorDesign.body(10, color: CuratorDesign.textLight).copyWith(height: 1.4)),
          ],
        ),
      ),
    );
  }
}
