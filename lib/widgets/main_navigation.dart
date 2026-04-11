import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/screens/home_screen.dart';
import 'package:mallu_smart/screens/all_products_screen.dart';
import 'package:mallu_smart/screens/cart_screen.dart';
import 'package:mallu_smart/widgets/premium_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _drawerController;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _drawerController.forward();
      } else {
        _drawerController.reverse();
      }
    });
  }

  void setTabIndex(int index) {
    if (_isDrawerOpen) toggleDrawer();
    HapticFeedback.mediumImpact();
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const AllProductsScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black, // Background behind the perspective
      body: Stack(
        children: [
          // 1. The Drawer (Behind)
          const PremiumDrawer(),
          
          // 2. Main Content with Perspective Animation
          AnimatedBuilder(
            animation: _drawerController,
            builder: (context, child) {
              double slide = 250.0 * _drawerController.value;
              double scale = 1.0 - (_drawerController.value * 0.15);
              double rotate = -0.1 * _drawerController.value;
              
              return Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale)
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(rotate),
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_drawerController.value * 30),
                  child: Stack(
                    children: [
                      child!,
                      // Overlay to dim content when drawer is open
                      if (_isDrawerOpen)
                        GestureDetector(
                          onTap: toggleDrawer,
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                // Content with smooth transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutQuart,
                  switchOutCurve: Curves.easeInQuart,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_currentIndex),
                    child: _pages[_currentIndex],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.02, curve: Curves.easeOutQuart),
          
          // 3. Floating Modern Navigation Bar (Always on top, or can be tied to perspective)
          AnimatedBuilder(
            animation: _drawerController,
            builder: (context, child) {
              return Positioned(
                left: 24,
                right: 24,
                bottom: 32 - (_drawerController.value * 100), // Hide navbar when drawer is open
                child: Opacity(
                  opacity: 1.0 - _drawerController.value,
                  child: _ModernFloatingNavBar(
                    selectedIndex: _currentIndex,
                    onTabSelected: setTabIndex,
                  ),
                ),
              );
            }
          ),

          // Custom Menu Button (since we removed standard Scaffold drawer)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: AnimatedBuilder(
              animation: _drawerController,
              builder: (context, _) {
                return IconButton(
                  icon: Icon(
                    _isDrawerOpen ? Icons.close_rounded : Icons.menu_rounded,
                    color: CuratorDesign.textDark,
                  ),
                  onPressed: toggleDrawer,
                );
              }
            ).animate().scale(delay: 400.ms, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
          ),
        ],
      ),
    );
  }
}

class _ModernFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const _ModernFloatingNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Sliding Active Indicator
              AnimatedPositioned(
                duration: 400.ms,
                curve: Curves.easeOutBack,
                left: _getIndicatorPosition(MediaQuery.of(context).size.width - 68), // 48 is total horizontal padding + margin
                top: 10,
                bottom: 10,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 88) / 3,
                  decoration: BoxDecoration(
                    gradient: CuratorDesign.primaryGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: CuratorDesign.primaryOrange.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                ),
              ),
              
              // Nav Items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'HOME',
                    isSelected: selectedIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  _NavBarItem(
                    index: 1,
                    icon: Icons.storefront_rounded,
                    label: 'SHOP',
                    isSelected: selectedIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                  _NavBarItem(
                    index: 2,
                    isCart: true,
                    icon: Icons.shopping_bag_rounded,
                    label: 'CART',
                    isSelected: selectedIndex == 2,
                    onTap: () => onTabSelected(2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 800.ms, curve: Curves.easeOutQuart).fadeIn();
  }

  double _getIndicatorPosition(double totalWidth) {
    double itemWidth = (totalWidth - 20) / 3;
    return (selectedIndex * itemWidth);
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCart;

  const _NavBarItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isCart ? const CartBadgeWrapper() : Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white38,
              size: 24,
            ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
            const SizedBox(height: 4),
            Text(
              label,
              style: CuratorDesign.label(
                8,
                color: isSelected ? Colors.white : Colors.white38,
              ).copyWith(letterSpacing: 1, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class CartBadgeWrapper extends StatelessWidget {
  const CartBadgeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, int>(
      selector: (_, provider) => provider.items.length,
      builder: (context, count, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 24),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: CuratorDesign.primaryOrange,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ).animate(key: ValueKey(count)).scale().shake(),
          ],
        );
      },
    );
  }
}

