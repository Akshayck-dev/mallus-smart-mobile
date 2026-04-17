import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mallu_smart/data/models/cart_item.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:mallu_smart/providers/order_provider.dart';
import 'package:mallu_smart/data/services/order_service.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:mallu_smart/screens/order_success_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPlaceOrderPressed = false;

  double get _total => widget.cartItems.fold(
        0.0,
        (sum, item) =>
            sum + (item.product['price'] as num).toDouble() * item.quantity,
      );

  // ── Place Order ───────────────────────────────────────────────────
  Future<void> _handlePlaceOrder() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final orderProvider = context.read<OrderProvider>();
    
    final success = await orderProvider.placeOrder(
      name: _nameController.text,
      address: _addressController.text,
      mobile: _phoneController.text,
      email: _emailController.text,
      cartItems: widget.cartItems,
    );

    if (!mounted) return;

    if (success) {
      context.read<CartProvider>().clearCart();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OrderSuccessScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to sync order. Please try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = OrderService.groupBySeller(widget.cartItems);
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // ── Main Content ─────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Shipping Details'),
                const SizedBox(height: 16),
                _buildForm(context),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Order Summary'),
                const SizedBox(height: 16),
                _buildOrderSummary(context, grouped),
              ],
            ),
          ),

          // ── Full-Screen Loading Overlay ──────────────────────────
          if (orderProvider.isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 36),
                      decoration: BoxDecoration(
                        color: CuratorDesign.surfaceColor(context),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                              color: CuratorDesign.primary, strokeWidth: 3),
                          const SizedBox(height: 24),
                          Text('Processing Order...',
                              style: CuratorDesign.label(16,
                                  color: CuratorDesign.textPrimary(context))),
                          const SizedBox(height: 8),
                          Text('Securing your items',
                              style: CuratorDesign.subtitle(
                                      color: CuratorDesign.textSecondary(context))
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                    )
                        .animate()
                        .scale(duration: 300.ms, curve: Curves.easeOutBack),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context, orderProvider),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Bounceable(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            color: CuratorDesign.textPrimary(context), size: 18),
      ),
      title: Text(
        'Checkout',
        style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context))
            .copyWith(fontSize: 20),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context))
          .copyWith(fontSize: 18),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  // ── Form ──────────────────────────────────────────────────────────
  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CuratorDesign.cardDecoration(
          Theme.of(context).brightness == Brightness.dark),
      child: Column(
        children: [
          _buildField('Your Name', _nameController, Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _buildField('Mobile Number', _phoneController,
              Icons.phone_android_rounded,
              keyboard: TextInputType.phone),
          const SizedBox(height: 16),
          _buildField('Email (optional)', _emailController,
              Icons.alternate_email_rounded,
              keyboard: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildField('Delivery Address', _addressController,
              Icons.location_on_outlined,
              maxLines: 3),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildField(
      String hint, TextEditingController controller, IconData icon,
      {TextInputType? keyboard, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: CuratorDesign.body(14, color: CuratorDesign.textPrimary(context)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: CuratorDesign.subtitle(
                color: CuratorDesign.textSecondary(context))
            .copyWith(fontSize: 14),
        prefixIcon: Icon(icon, color: CuratorDesign.primary, size: 20),
        filled: true,
        fillColor: CuratorDesign.surfaceLowColor(context),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: CuratorDesign.primary.withValues(alpha: 0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CuratorDesign.primary, width: 1.5),
        ),
      ),
    );
  }

  // ── Order Summary (grouped by seller) ────────────────────────────
  Widget _buildOrderSummary(
      BuildContext context, Map<String, List<CartItem>> grouped) {
    return Column(
      children: [
        ...grouped.entries.toList().asMap().entries.map((mapEntry) {
          final delay = mapEntry.key;
          final entry = mapEntry.value;
          final sellerItems = entry.value;
          final seller = sellerItems.first.product['seller'];
          final sellerName = (seller is Map ? seller['name'] : 'Seller')
              as String? ??
              'Seller';
          final sellerPhone = (seller is Map ? seller['phone'] : '') as String;
          final sellerTotal = sellerItems.fold<double>(
              0,
              (s, i) =>
                  s + (i.product['price'] as num).toDouble() * i.quantity);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: CuratorDesign.cardDecoration(
                Theme.of(context).brightness == Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CuratorDesign.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.storefront_rounded,
                          color: CuratorDesign.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sellerName,
                              style: CuratorDesign.heading(
                                      color: CuratorDesign.textPrimary(context))
                                  .copyWith(fontSize: 14)),
                          Text('+$sellerPhone',
                              style: CuratorDesign.label(11,
                                  color: CuratorDesign.textSecondary(context))),
                        ],
                      ),
                    ),
                    /* WhatsApp Badge Removed for Standard E-Com View */
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                ...sellerItems.map((item) {
                  final name = item.product['name'] ?? 'Product';
                  final price = (item.product['price'] as num).toDouble();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(name,
                              style: CuratorDesign.body(14,
                                  color: CuratorDesign.textPrimary(context),
                                  weight: FontWeight.w500)),
                        ),
                        Text('×${item.quantity}',
                            style: CuratorDesign.label(12,
                                color: CuratorDesign.textSecondary(context))),
                        const SizedBox(width: 16),
                        Text('₹${(price * item.quantity).toStringAsFixed(0)}',
                            style: CuratorDesign.label(14,
                                color: CuratorDesign.textPrimary(context),
                                weight: FontWeight.w700)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Seller total: ',
                        style: CuratorDesign.label(13,
                            color: CuratorDesign.textSecondary(context))),
                    Text('₹${sellerTotal.toStringAsFixed(0)}',
                        style: CuratorDesign.price(color: CuratorDesign.primary)
                            .copyWith(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: (400 + delay * 150).ms, duration: 500.ms);
        }),
        // 🔥 TOTAL SUMMARY REMOVED FROM HERE TO BECOME STICKY
      ],
    );
  }

  // ── Bottom CTA ─────────────────────────────────────────────────────
  Widget _buildBottomActions(BuildContext context, OrderProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Sticky Total Amount ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount',
                      style: CuratorDesign.heading(color: CuratorDesign.textPrimary(context))
                          .copyWith(fontSize: 15)),
                  Text('₹${_total.toStringAsFixed(0)}',
                      style: CuratorDesign.price(color: CuratorDesign.primary)
                          .copyWith(fontSize: 22)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Place Order Button ──
            GestureDetector(
              onTapDown: (_) => setState(() => _isPlaceOrderPressed = true),
              onTapUp: (_) => setState(() => _isPlaceOrderPressed = false),
              onTapCancel: () => setState(() => _isPlaceOrderPressed = false),
              onTap: provider.isLoading ? null : _handlePlaceOrder,
              child: AnimatedScale(
                scale: _isPlaceOrderPressed ? 0.96 : 1.0,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: CuratorDesign.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: CuratorDesign.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Submit Order',
                                style: CuratorDesign.label(15,
                                    color: Colors.white, weight: FontWeight.w700),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
