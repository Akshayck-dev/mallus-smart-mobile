import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedIndex = index);
              widget.onCategorySelected(widget.categories[index]);
            },
            child: AnimatedContainer(
              duration: 400.ms,
              curve: Curves.easeOutQuart,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected ? CuratorDesign.primaryIndigo : (Theme.of(context).brightness == Brightness.dark ? CuratorDesign.darkSurfaceLow : Colors.white),
                borderRadius: BorderRadius.circular(CuratorDesign.radius / 2),
                border: Border.all(color: isSelected ? Colors.transparent : CuratorDesign.textPrimary(context).withValues(alpha: 0.05)),

                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  widget.categories[index].toUpperCase(),
                  style: CuratorDesign.label(
                    11, 
                    color: isSelected ? Colors.white : CuratorDesign.textSecondary(context)
                  ).copyWith(letterSpacing: 2, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ).animate(target: isSelected ? 1 : 0)
             .scale(
               begin: const Offset(1, 1), 
               end: const Offset(1.05, 1.05),
               duration: 300.ms, 
               curve: Curves.easeOutBack
             ),
          );
        },
      ),
    );
  }
}
