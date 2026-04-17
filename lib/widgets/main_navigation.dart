import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/premium_drawer.dart';
import 'package:mallu_smart/screens/home_screen.dart';
import 'package:mallu_smart/screens/shops_explorer_screen.dart';
import 'package:mallu_smart/screens/cart_screen.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HomeScreen(openDrawer: openDrawer),
          item: ItemConfig(
            icon: const Icon(Icons.home_rounded),
            title: "HOME",
            activeForegroundColor: CuratorDesign.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ShopsExplorerScreen(openDrawer: openDrawer),
          item: ItemConfig(
            icon: const Icon(Icons.grid_view_rounded),
            title: "SHOP",
            activeForegroundColor: CuratorDesign.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: CartScreen(openDrawer: openDrawer),
          item: ItemConfig(
            icon: const Icon(Icons.shopping_cart_rounded),
            title: "CART",
            activeForegroundColor: CuratorDesign.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CuratorDesign.surfaceColor(context),
      drawer: const PremiumDrawer(),
      body: PersistentTabView(
        controller: _controller,
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => _PremiumNavBar(navBarConfig),
        backgroundColor: Colors.transparent, 
        resizeToAvoidBottomInset: true,
        handleAndroidBackButtonPress: true,
        stateManagement: true,
      ),
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;

  const _PremiumNavBar(this.navBarConfig);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding > 0 ? bottomPadding : 24),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F16) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: CuratorDesign.primary.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
                  children: [
                    _SlidingIndicator(
                      selectedIndex: navBarConfig.selectedIndex,
                      itemCount: navBarConfig.items.length,
                    ),
                    Row(
                      children: navBarConfig.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isSelected = navBarConfig.selectedIndex == index;
                        final color = isSelected ? item.activeForegroundColor : item.inactiveForegroundColor;
    
                        return Expanded(
                          child: Bounceable(
                            onTap: () => navBarConfig.onItemSelected(index),
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 🛒 Cart Badge (only on CART tab, index == 2)
                                  index == 2
                                      ? Consumer<CartProvider>(
                                          builder: (context, cart, _) {
                                            final count = cart.items.length;
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Icon(
                                                  (item.icon as Icon).icon,
                                                  color: color,
                                                  size: isSelected ? 24 : 22,
                                                ).animate(target: isSelected ? 1 : 0).scale(
                                                  begin: const Offset(0.8, 0.8),
                                                  end: const Offset(1, 1)),
                                                if (count > 0)
                                                  Positioned(
                                                    right: -6,
                                                    top: -6,
                                                    child: AnimatedScale(
                                                      scale: count > 0 ? 1 : 0,
                                                      duration: const Duration(milliseconds: 200),
                                                      curve: Curves.easeOutBack,
                                                      child: Container(
                                                        constraints: const BoxConstraints(
                                                          minWidth: 16, minHeight: 16),
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.redAccent,
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(
                                                              color: Colors.white, width: 1.5),
                                                        ),
                                                        child: Text(
                                                          count > 9 ? '9+' : '$count',
                                                          style: const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight: FontWeight.w800,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ).animate().scale(
                                                      duration: 300.ms,
                                                      curve: Curves.easeOutBack),
                                                  ),
                                              ],
                                            );
                                          },
                                        )
                                      : Icon(
                                          (item.icon as Icon).icon,
                                          color: color,
                                          size: isSelected ? 24 : 22,
                                        ).animate(target: isSelected ? 1 : 0).scale(
                                          begin: const Offset(0.8, 0.8),
                                          end: const Offset(1, 1)),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.title ?? "",
                                    style: CuratorDesign.label(
                                      10,
                                      weight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                      color: color,
                                    ).copyWith(letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
          ),
        ),
          ),
      );
  }
}

class _SlidingIndicator extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;

  const _SlidingIndicator({
    required this.selectedIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width - 48; // Padding 24x2
    final itemWidth = availableWidth / itemCount;
    final pillWidth = 56.0;
    
    return AnimatedPositioned(
      duration: 500.ms,
      curve: Curves.easeOutQuart,
      left: (selectedIndex * itemWidth) + (itemWidth - pillWidth) / 2,
      top: 10,
      bottom: 10,
      child: Container(
        width: pillWidth,
        decoration: BoxDecoration(
          color: CuratorDesign.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
