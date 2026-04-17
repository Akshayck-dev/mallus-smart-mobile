import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText._({
    required this.text,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  factory AppText.title(
    String text, {
    Color? color,
    double? size,
    FontWeight? weight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      text: text,
      style: CuratorDesign.title(color: color).copyWith(
        fontSize: size,
        fontWeight: weight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.subtitle(
    String text, {
    Color? color,
    double? size,
    FontWeight? weight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AppText._(
      text: text,
      style: CuratorDesign.subtitle(color: color).copyWith(
        fontSize: size,
        fontWeight: weight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  factory AppText.price(
    double amount, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText._(
      text: '₹${amount.toStringAsFixed(2)}',
      style: CuratorDesign.price(color: color),
      textAlign: textAlign,
    );
  }

  factory AppText.label(
    String text, {
    Color? color,
    double size = 12,
    FontWeight? weight,
    TextAlign? textAlign,
  }) {
    return AppText._(
      text: text,
      style: CuratorDesign.label(size, color: color, weight: weight),
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
