import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/data/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareOrderModal extends StatelessWidget {
  final Product? product;
  final String? orderMessage;
  const ShareOrderModal({super.key, this.product, this.orderMessage});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: CuratorDesign.surfaceColor(context),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Share Order',
                      style: CuratorDesign.display(18, weight: FontWeight.w800, color: CuratorDesign.primaryIndigo),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: CuratorDesign.textSecondary(context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: CuratorDesign.textSecondary(context).withValues(alpha: 0.05)),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Let your inner circle know about your latest find.',
                      textAlign: TextAlign.center,
                      style: CuratorDesign.body(14, color: CuratorDesign.textSecondary(context)),
                    ),
                    const SizedBox(height: 32),
                    
                    // Editorial Share Card
                    _buildShareCard(context),
                    
                    const SizedBox(height: 32),
                    
                    // Share Actions
                    _buildShareActions(context),
                    
                    const SizedBox(height: 24),
                    
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Skip for now',
                        style: CuratorDesign.label(12, weight: FontWeight.w700, color: CuratorDesign.primaryIndigo)
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
    );
  }

  Widget _buildShareCard(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CuratorDesign.primaryIndigo.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Product Image
              Positioned.fill(
                child: product != null 
                  ? CachedNetworkImage(
                      imageUrl: product!.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: CuratorDesign.surfaceLowColor(context),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: CuratorDesign.primaryIndigo),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: CuratorDesign.surfaceLowColor(context),
                        child: const Center(
                          child: Icon(Icons.broken_image_rounded, color: Colors.white, size: 40),
                        ),
                      ),
                    )
                  : Container(color: CuratorDesign.surfaceLowColor(context)),
              ),
              
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        CuratorDesign.primaryIndigo.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Brand Logo (Top Left)
              Positioned(
                top: 24,
                left: 24,
                child: Text(
                  'MALLU SMART',
                  style: CuratorDesign.display(16, weight: FontWeight.w800, color: Colors.white)
                      .copyWith(letterSpacing: 4),
                ),
              ),
              
              // Shopping Bag Icon (Top Right)
              Positioned(
                top: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 16),
                ),
              ),
              
              // Product Info (Bottom)
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'VERIFIED ORDER',
                              style: CuratorDesign.label(8, weight: FontWeight.w800, color: Colors.white)
                                  .copyWith(letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product?.name ?? 'Lunar Series One',
                            style: CuratorDesign.display(24, weight: FontWeight.w800, color: Colors.white)
                                .copyWith(height: 1.1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Arriving in 3-5 business days',
                            style: CuratorDesign.body(11, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'VALUE',
                          style: CuratorDesign.label(8, weight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.5))
                              .copyWith(letterSpacing: 2),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${product?.price.toStringAsFixed(2) ?? '245.00'}',
                          style: CuratorDesign.display(18, weight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareActions(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            HapticFeedback.heavyImpact();
            final message = orderMessage ?? "I am interested to buy this item from Mallu Smart: ${product?.name ?? 'Collection'}";
            final whatsappUrl = "https://wa.me/?text=${Uri.encodeComponent(message)}";
            final uri = Uri.parse(whatsappUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch WhatsApp')),
                );
              }
            }
          },
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CuratorDesign.primaryIndigo, CuratorDesign.primaryIndigo.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: CuratorDesign.primaryIndigo.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Share via WhatsApp',
                  style: CuratorDesign.label(14, weight: FontWeight.w800, color: Colors.white)
                      .copyWith(letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSecondaryAction(context, Icons.content_copy_rounded, 'Copy Link')),
            const SizedBox(width: 12),
            Expanded(child: _buildSecondaryAction(context, Icons.ios_share_rounded, 'More')),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryAction(BuildContext context, IconData icon, String label) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: CuratorDesign.surfaceLowColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: CuratorDesign.primaryIndigo),
          const SizedBox(width: 8),
          Text(
            label,
            style: CuratorDesign.label(11, weight: FontWeight.w800, color: CuratorDesign.primaryIndigo),
          ),
        ],
      ),
    );
  }
}
