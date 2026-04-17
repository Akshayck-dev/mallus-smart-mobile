import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';

class CuratorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const CuratorAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: (isDark ? CuratorDesign.darkSurface : CuratorDesign.surface).withValues(alpha: 0.5),
          ),
        ),
      ),
      leading: leading ?? (showBackButton 
        ? IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: CuratorDesign.textPrimary(context), size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ) 
        : null),
      title: Text(
        title.toUpperCase(),
        style: CuratorDesign.display(14, color: CuratorDesign.textPrimary(context), weight: FontWeight.w800)
            .copyWith(letterSpacing: 4),
      ),

      actions: actions ?? [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none_rounded, color: CuratorDesign.textPrimary(context), size: 22),
        ),
        const SizedBox(width: CuratorDesign.s8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
