import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:mallu_smart/widgets/deep_heat_button.dart';
import 'package:mallu_smart/widgets/main_navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _pageOffset = 0;
  int _currentPage = 0;

  final List<OnboardingData> _screens = [
    OnboardingData(
      title: 'Curated for the\nConnoisseur',
      subtitle:
          'Discover the finest selections, handpicked for quality. Elevate your everyday essentials into an editorial experience.',
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1200&auto=format&fit=crop',
      tag: 'EXPERIENCE EXCELLENCE',
    ),
    OnboardingData(
      title: 'Arrives in 10\nMinutes',
      subtitle:
          'Your essentials delivered with speed and care, every time. Experience the new standard of urban logistics.',
      imageUrl:
          'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?q=80&w=1200&auto=format&fit=crop',
      tag: 'DELIVERY PHASE',
    ),
    OnboardingData(
      title: 'Sustainable &\nLocally Sourced',
      subtitle:
          'Supporting local farmers while minimizing our carbon footprint. Freshness that makes a difference in your community.',
      imageUrl:
          'https://images.unsplash.com/photo-1506484334402-40f21503fd0d?q=80&w=1200&auto=format&fit=crop',
      tag: 'ECO CONSCIOUS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuart,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_launch', false);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Parallax Background
          ...List.generate(_screens.length, (index) {
            final double offset = (index - _pageOffset);
            return Positioned.fill(
              child: Opacity(
                opacity: (1 - offset.abs()).clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(offset * 100, 0), // Parallax shift
                  child: CachedNetworkImage(
                    imageUrl: _screens[index].imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.black),
                  ),
                ),
              ),
            );
          }),

          // Gradient Overlay for Readability
          const Positioned.fill(
            child: DecorateBackground(),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _screens.length,
            itemBuilder: (context, index) {
              final data = _screens[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 12),
                    
                    Text(
                      data.tag,
                      style: CuratorDesign.label(12, color: Colors.white70),
                    ).animate(key: ValueKey('tag_$index'))
                     .fadeIn(duration: 600.ms)
                     .slideX(begin: 0.1),
                    
                    const SizedBox(height: 12),
                    
                    RichText(
                      text: TextSpan(
                        style: CuratorDesign.display(42, color: Colors.white),
                        children: [
                          TextSpan(text: data.title.split('\n')[0] + '\n'),
                          TextSpan(
                            text: data.title.split('\n')[1],
                            style: const TextStyle(color: CuratorDesign.primaryOrange),
                          ),
                        ],
                      ),
                    ).animate(key: ValueKey('title_$index'))
                     .fadeIn(delay: 200.ms, duration: 800.ms)
                     .slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      data.subtitle,
                      style: CuratorDesign.body(16, color: Colors.white.withValues(alpha: 0.8)),
                    ).animate(key: ValueKey('sub_$index'))
                     .fadeIn(delay: 400.ms, duration: 800.ms)
                     .slideY(begin: 0.05),
                    
                    const Spacer(flex: 3),
                  ],
                ),
              );
            },
          ),
          
          // Branding Logo (Top Left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 32,
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ).animate().fadeIn(duration: 1.seconds).slideX(begin: -0.1),
          ),

          // Progress Indicator & Button (Bottom)
          Positioned(
            bottom: 50,
            left: 32,
            right: 32,
            child: Column(
              children: [
                Row(
                  children: [
                    // Fluid Progress Indicator
                    Expanded(
                      child: Row(
                        children: List.generate(
                          _screens.length,
                          (idx) => Expanded(
                            child: Container(
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: idx <= _currentPage ? double.infinity : 0,
                                    decoration: BoxDecoration(
                                      color: idx == _currentPage ? CuratorDesign.primaryOrange : Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Counter
                    Text(
                      '0${_currentPage + 1}',
                      style: CuratorDesign.display(16, color: Colors.white),
                    ),
                    Text(
                      ' / 0${_screens.length}',
                      style: CuratorDesign.display(12, color: Colors.white38),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                DeepHeatButton(
                  text: _currentPage == _screens.length - 1 ? 'GET STARTED' : 'CONTINUE',
                  onTap: _onNext,
                ),
              ],
            ),
          ),
          
          // Glassmorphic Skip Button (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.white.withValues(alpha: 0.05),
                child: InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('is_first_launch', false);
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigation()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'SKIP',
                      style: CuratorDesign.label(12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1.seconds),
        ],
      ),
    );
  }
}

class DecorateBackground extends StatelessWidget {
  const DecorateBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.4),
            Colors.black.withValues(alpha: 0.0),
            Colors.black.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.95),
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
  });
}
