import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:mallu_smart/providers/theme_provider.dart';
import 'package:mallu_smart/screens/favorites_screen.dart';
import 'package:mallu_smart/providers/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumDrawer extends StatelessWidget {
  const PremiumDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.75),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Column(
            children: [
              // Premium Header
              _buildModernHeader(context),

              // Scrollable Menu
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionHeader('CURATOR NAV'),
                    _ModernDrawerItem(
                      icon: Icons.home_rounded,
                      title: 'DASHBOARD',
                      isSelected: true,
                      onTap: () => Navigator.pop(context),
                      index: 0,
                    ),
                    _ModernDrawerItem(
                      icon: Icons.shopping_bag_rounded,
                      title: 'ORDERS',
                      onTap: () {},
                      index: 1,
                    ),
                    _ModernDrawerItem(
                      icon: Icons.favorite_rounded,
                      title: 'FAVORITES',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                      },
                      index: 2,
                    ),
                    
                    const SizedBox(height: 32),
                    _buildSectionHeader('COLLECTIONS'),
                    _ModernDrawerItem(
                      icon: Icons.auto_awesome_rounded,
                      title: 'PREMIUM SELECTION',
                      onTap: () {},
                      index: 3,
                    ),
                    _ModernDrawerItem(
                      icon: Icons.category_rounded,
                      title: 'EXPLORE ALL',
                      onTap: () {},
                      index: 4,
                    ),
                    
                    const SizedBox(height: 32),
                    _buildSectionHeader('PREFERENCES'),
                    _buildThemeToggle(context),
                    _buildLanguageItem(context),
                  ],
                ),
              ),

              // Footer
              _buildModernFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: CuratorDesign.premiumGradient,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.apps_rounded, size: 200, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: CuratorDesign.surfaceLow,
                    child: Icon(Icons.person_rounded, size: 35, color: CuratorDesign.primaryOrange),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 20),
                Text(
                  'GUEST USER',
                  style: CuratorDesign.display(20, color: Colors.white).copyWith(letterSpacing: 2),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'EXCLUSIVE ACCESS',
                    style: CuratorDesign.label(8, color: Colors.white).copyWith(letterSpacing: 2),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 24, 16),
      child: Text(
        title,
        style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 3),
      ),
    ).animate().fadeIn();
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => _ModernDrawerItem(
        icon: theme.themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        title: 'LUXURY THEME',
        onTap: () => theme.toggleTheme(theme.themeMode == ThemeMode.light),
        trailing: Switch.adaptive(
          activeColor: CuratorDesign.primaryOrange,
          value: theme.themeMode == ThemeMode.dark,
          onChanged: (val) => theme.toggleTheme(val),
        ),
        index: 5,
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lang, _) {
        bool isMalayalam = lang.currentLanguage == AppLanguage.malayalam;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GLOBAL ACCESS',
                style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Stack(
                  children: [
                    // Moving Background Indicator
                    AnimatedAlign(
                      duration: 300.ms,
                      curve: Curves.easeOutQuart,
                      alignment: isMalayalam ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: CuratorDesign.primaryOrange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: CuratorDesign.primaryOrange.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                      ),
                    ),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (isMalayalam) {
                                HapticFeedback.lightImpact();
                                lang.toggleLanguage();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'English',
                                style: CuratorDesign.label(12, color: !isMalayalam ? Colors.white : CuratorDesign.textLight),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!isMalayalam) {
                                HapticFeedback.lightImpact();
                                lang.toggleLanguage();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'മലയാളം',
                                style: CuratorDesign.label(14, color: isMalayalam ? Colors.white : CuratorDesign.textLight),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'MALLU MART',
                style: CuratorDesign.display(12, color: CuratorDesign.textLight).copyWith(letterSpacing: 2),
              ),
              const Spacer(),
              Text(
                'v1.2.0',
                style: CuratorDesign.label(10, color: CuratorDesign.textLight.withValues(alpha: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: CuratorDesign.primaryOrange.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'LOG OUT',
                  style: CuratorDesign.label(12, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final Widget? trailing;
  final int index;

  const _ModernDrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.index,
    this.isSelected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).textTheme.bodyLarge?.color;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: 300.ms,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? CuratorDesign.primaryOrange.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? CuratorDesign.primaryOrange : themeColor?.withValues(alpha: 0.8),
                  size: 22,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: CuratorDesign.label(13, color: isSelected ? CuratorDesign.primaryOrange : themeColor).copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                trailing ?? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: themeColor?.withValues(alpha: 0.2),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (100 + (index * 50)).ms).slideX(begin: 0.05),
        ),
      ),
    );
  }
}
