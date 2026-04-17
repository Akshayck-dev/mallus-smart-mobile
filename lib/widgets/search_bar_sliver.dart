import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';

class SearchBarSliver extends StatelessWidget {
  const SearchBarSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? CuratorDesign.darkSurfaceLow : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.05) 
                  : Colors.black.withValues(alpha: 0.05),
              width: 1.5,
            ),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(
                Icons.search_rounded,
                color: isDark ? CuratorDesign.darkTextSecondary : CuratorDesign.textLight,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for groceries...',
                    hintStyle: CuratorDesign.body(14, 
                      color: isDark ? CuratorDesign.darkTextSecondary : CuratorDesign.textLight
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CuratorDesign.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: CuratorDesign.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
