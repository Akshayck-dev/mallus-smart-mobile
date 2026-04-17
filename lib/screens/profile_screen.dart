import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildBoutiqueHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildEditorialProfile(context, isDark),
                    const SizedBox(height: 48),
                    _buildActionList(context, isDark),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoutiqueHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleAction(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            isDark: isDark,
          ),
          Text(
            'Account',
            style: CuratorDesign.label(16, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87),
          ),
          _CircleAction(
            icon: Icons.settings_outlined,
            onTap: () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialProfile(BuildContext context, bool isDark) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1), width: 1),
              ),
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, size: 48, color: isDark ? Colors.white38 : Colors.black26),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
              ),
            ),
          ],
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 24),
        Text(
          'MALLU SMART USER', 
          style: CuratorDesign.display(20, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          'Verified Collector since 2024', 
          style: CuratorDesign.label(10, weight: FontWeight.w800, color: CuratorDesign.textLight).copyWith(letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildActionList(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildItem(context, isDark, Icons.shopping_bag_outlined, 'My Orders', 'Track and manage deliveries'),
        _buildItem(context, isDark, Icons.favorite_border_rounded, 'Favorites', 'Curated collections'),
        _buildItem(context, isDark, Icons.location_on_outlined, 'Addresses', 'Shipping destinations'),
        _buildItem(context, isDark, Icons.payment_rounded, 'Payment', 'Secure transaction methods'),
        _buildItem(context, isDark, Icons.help_outline_rounded, 'Support', 'Boutique assistance'),
        const SizedBox(height: 12),
        _buildItem(context, isDark, Icons.logout_rounded, 'Sign Out', 'Safely leave your account', isDestructive: true),
      ],
    );
  }

  Widget _buildItem(BuildContext context, bool isDark, IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Bounceable(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? Colors.red.withValues(alpha: 0.1) 
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black), size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CuratorDesign.label(13, weight: FontWeight.w800, color: isDestructive ? Colors.redAccent : (isDark ? Colors.white : Colors.black)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: CuratorDesign.body(11, color: CuratorDesign.textLight),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: isDark ? Colors.white24 : Colors.black12),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _CircleAction({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFF0F0F0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 18),
      ),
    );
  }
}
