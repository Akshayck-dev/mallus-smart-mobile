import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';

class PremiumDrawer extends StatelessWidget {
  const PremiumDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.82,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F16) : Colors.white,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 40,
              offset: const Offset(10, 0),
            )
          ],
          border: Border.all(
            color: CuratorDesign.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 20),
              const Divider(indent: 24, endIndent: 24, height: 1),
              const SizedBox(height: 24),
              Expanded(
                child: _buildNavigationItems(context),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CuratorDesign.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: CuratorDesign.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person_outline_rounded, size: 40, color: Colors.white),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            "Mallu Smart",
            style: CuratorDesign.title(color: CuratorDesign.textPrimary(context)).copyWith(fontSize: 24),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 4),
          Text(
            "Authentic Kerala Explorer",
            style: CuratorDesign.subtitle(color: CuratorDesign.textSecondary(context)).copyWith(fontSize: 13),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    final items = [
      _DrawerItemData(Icons.home_outlined, "Home"),
      _DrawerItemData(Icons.shopping_bag_outlined, "My Orders"),
      _DrawerItemData(Icons.favorite_outline_rounded, "Favorites"),
      _DrawerItemData(Icons.storefront_rounded, "Top Artisans"),
      _DrawerItemData(Icons.help_outline_rounded, "Support"),
      _DrawerItemData(Icons.settings_outlined, "Settings"),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _DrawerTile(data: items[index]).animate().fadeIn(delay: (400 + index * 50).ms).slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "v1.5.0 Premium",
            style: CuratorDesign.label(10, color: CuratorDesign.textSecondary(context).withValues(alpha: 0.5)),
          ),
          Bounceable(
            onTap: () {},
            child: Icon(Icons.logout_rounded, color: Colors.redAccent.withValues(alpha: 0.6), size: 20),
          ),
        ],
      ),
    );
  }
}

class _DrawerItemData {
  final IconData icon;
  final String title;
  _DrawerItemData(this.icon, this.title);
}

class _DrawerTile extends StatelessWidget {
  final _DrawerItemData data;
  const _DrawerTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(data.icon, color: CuratorDesign.primary, size: 22),
            const SizedBox(width: 16),
            Text(
              data.title,
              style: CuratorDesign.label(15, color: CuratorDesign.textPrimary(context), weight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
