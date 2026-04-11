import 'package:flutter/material.dart';
import 'package:mallu_smart/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            elevation: 0,
            backgroundColor: CuratorDesign.textDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: CuratorDesign.premiumGradient,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.person_rounded, size: 300, color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 45,
                              backgroundColor: CuratorDesign.surfaceLow,
                              child: Icon(Icons.person_rounded, size: 45, color: CuratorDesign.primaryOrange),
                            ),
                          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 16),
                          Text(
                            'GUEST USER',
                            style: CuratorDesign.display(24, color: Colors.white).copyWith(letterSpacing: 2),
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                          const SizedBox(height: 4),
                          Text(
                            'PREMIUM MEMBER',
                            style: CuratorDesign.label(10, color: Colors.white70).copyWith(letterSpacing: 4),
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACCOUNT SETTINGS',
                    style: CuratorDesign.label(10, color: CuratorDesign.textLight).copyWith(letterSpacing: 2),
                  ).animate().fadeIn(),
                  const SizedBox(height: 24),
                  _buildProfileGroup([
                    _ProfileItem(icon: Icons.shopping_bag_outlined, title: 'Order History'),
                    _ProfileItem(icon: Icons.location_on_outlined, title: 'Saved Addresses'),
                    _ProfileItem(icon: Icons.payment_rounded, title: 'Payment Cards'),
                  ]),
                  const SizedBox(height: 32),
                  Text(
                    'SECURITY',
                    style: CuratorDesign.label(10, color: CuratorDesign.textLight).copyWith(letterSpacing: 2),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileGroup([
                    _ProfileItem(icon: Icons.shield_outlined, title: 'Privacy Settings'),
                    _ProfileItem(icon: Icons.notifications_none_rounded, title: 'Notification Preferences'),
                  ]),
                  const SizedBox(height: 32),
                  _ProfileItem(
                    icon: Icons.logout_rounded, 
                    title: 'Log Out', 
                    color: Colors.redAccent,
                    isLast: true,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final bool isLast;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.black.withOpacity(0.03))),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? CuratorDesign.textDark).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? CuratorDesign.textDark, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: CuratorDesign.label(13, color: color ?? CuratorDesign.textDark),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: CuratorDesign.textLight.withOpacity(0.3)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }
}
