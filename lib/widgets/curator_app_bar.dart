import 'package:flutter/material.dart';
import 'package:mallu_smart/utils/design_system.dart';

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
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: leading ?? (showBackButton ? const BackButton(color: Colors.black) : const Icon(Icons.menu, color: Colors.black)),
      title: Text(
        title,
        style: CuratorDesign.display(18),
      ),
      actions: actions ?? [
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications_none, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
