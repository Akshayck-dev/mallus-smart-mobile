import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.favorite_rounded,
      "title": "Support Local Sellers",
      "desc": "Empower Kerala artisans and discover authentic products crafted with care.",
      "color": CuratorDesign.primary,
    },
    {
      "icon": Icons.flash_on_rounded,
      "title": "Fast & Secure Ordering",
      "desc": "Enjoy a seamless shopping experience with quick delivery across Kerala.",
      "color": CuratorDesign.secondary,
    },
    {
      "icon": Icons.shopping_bag_rounded,
      "title": "Discover Local Products",
      "desc": "Find authentic Kerala products made by local sellers and micro-businesses.",
      "color": CuratorDesign.primary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < _pages.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuart,
        );
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _completeOnboarding() async {
    HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
              ? [CuratorDesign.darkSurface, CuratorDesign.darkSurfaceLow]
              : [const Color(0xFFF1F8E9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// SKIP BUTTON
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      "Skip",
                      style: CuratorDesign.label(14, color: CuratorDesign.textSecondary(context)),
                    ),
                  ),
                ),
              ),

              /// PAGE VIEW
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// ANIMATED ICON CARD
                        AnimatedScale(
                          scale: _currentIndex == index ? 1 : 0.85,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          child: Container(
                            height: 240,
                            width: 240,
                            decoration: BoxDecoration(
                              color: isDark 
                                ? CuratorDesign.darkCard.withOpacity(0.5) 
                                : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: (page["color"] as Color).withOpacity(0.15),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                page["icon"],
                                size: 90,
                                color: page["color"],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        /// TITLE
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            page["title"],
                            textAlign: TextAlign.center,
                            style: CuratorDesign.title(color: CuratorDesign.textPrimary(context))
                                .copyWith(fontSize: 28),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// DESCRIPTION
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            page["desc"],
                            textAlign: TextAlign.center,
                            style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context))
                                .copyWith(fontSize: 15, height: 1.6),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isSelected = _currentIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: isSelected ? 24 : 8,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? CuratorDesign.primary
                          : CuratorDesign.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 48),

              /// NEXT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GestureDetector(
                  onTap: _nextPage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: CuratorDesign.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CuratorDesign.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? "Get Started →"
                            : "Next →",
                        style: CuratorDesign.label(16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}