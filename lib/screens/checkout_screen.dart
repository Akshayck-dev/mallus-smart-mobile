import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/design_system.dart';
import '../providers/cart_provider.dart';
import '../widgets/deep_heat_button.dart';
import 'order_success_screen.dart';
import '../widgets/confetti_celebration.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPayment = 'CASH ON DELIVERY';

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        _pageController.nextPage(duration: 500.ms, curve: Curves.easeOutQuart);
        setState(() => _currentStep++);
      }
    } else if (_currentStep < 2) {
      _pageController.nextPage(duration: 500.ms, curve: Curves.easeOutQuart);
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: 500.ms, curve: Curves.easeOutQuart);
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _completeOrder() async {
    HapticFeedback.heavyImpact();
    final cart = context.read<CartProvider>();
    
    String orderSummary = "🛒 *NEW ORDER FROM MALLU'S MART*\n";
    orderSummary += "━━━━━━━━━━━━━━━━━━━━\n\n";
    for (var item in cart.items) {
      orderSummary += "📦 *${item.product.name}*\n";
      orderSummary += "   Qty: ${item.quantity} | Price: ₹${(item.product.price * item.quantity).toInt()}\n\n";
    }
    orderSummary += "💰 *TOTAL: ₹${cart.total.toInt()}*\n";
    orderSummary += "💳 *PAYMENT: $_selectedPayment*\n\n";
    orderSummary += "👤 *CUSTOMER*\n";
    orderSummary += "Name: ${_nameController.text}\n";
    orderSummary += "Phone: ${_phoneController.text}\n";
    orderSummary += "Address: ${_addressController.text}\n";

    const String businessNumber = "911234567890"; // WhatsApp Support number
    final whatsappUrl = "https://wa.me/$businessNumber?text=${Uri.encodeComponent(orderSummary)}";

    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      cart.clear();
      if (mounted) {
        showConfetti(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.surface,
      appBar: AppBar(
        backgroundColor: CuratorDesign.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CuratorDesign.textDark, size: 20),
          onPressed: _prevStep,
        ),
        title: _buildStepIndicator(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAddressStep(),
              _buildPaymentStep(),
              _buildReviewStep(),
            ],
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildGlassBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        bool isActive = index <= _currentStep;
        bool isCurrent = index == _currentStep;
        return AnimatedContainer(
          duration: 400.ms,
          curve: Curves.easeOutQuart,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 30 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? CuratorDesign.primaryOrange : CuratorDesign.textLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
            boxShadow: isCurrent ? [
              BoxShadow(color: CuratorDesign.primaryOrange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 2))
            ] : [],
          ),
        );
      }),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DELIVERY\nADDRESS', style: CuratorDesign.display(32, color: CuratorDesign.textDark).copyWith(height: 1.1)),
            const SizedBox(height: 32),
            _buildField('Full Name', _nameController, Icons.person_rounded),
            const SizedBox(height: 16),
            _buildField('Phone Number', _phoneController, Icons.phone_android_rounded, keyboard: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField('Street Address', _addressController, Icons.location_on_rounded, maxLines: 3),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildPaymentStep() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PAYMENT\nMETHOD', style: CuratorDesign.display(32, color: CuratorDesign.textDark).copyWith(height: 1.1)),
          const SizedBox(height: 32),
          _buildPaymentCard('CASH ON DELIVERY', 'Pay when your items arrive', Icons.payments_rounded),
          const SizedBox(height: 12),
          _buildPaymentCard('WHATSAPP PAY', 'Confirm payment via order chat', Icons.chat_bubble_rounded),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildReviewStep() {
    final cart = context.watch<CartProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONFIRM\nDETAILS', style: CuratorDesign.display(32, color: CuratorDesign.textDark).copyWith(height: 1.1)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Column(
              children: [
                ...cart.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Text('${item.quantity}x', style: CuratorDesign.label(12, color: CuratorDesign.primaryOrange)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item.product.name, style: CuratorDesign.body(14))),
                      Text('₹${(item.product.price * item.quantity).toInt()}', style: CuratorDesign.label(14)),
                    ],
                  ),
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: Colors.black12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('GRAND TOTAL', style: CuratorDesign.label(12)),
                    Text('₹${cart.total.toInt()}', style: CuratorDesign.display(24, color: CuratorDesign.textDark)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoRow('DELIVERY TO', _nameController.text),
          _buildInfoRow('ADDRESS', _addressController.text),
          _buildInfoRow('PAYMENT VIA', _selectedPayment),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType? keyboard}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: CuratorDesign.label(8, color: CuratorDesign.textLight).copyWith(letterSpacing: 2)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            style: CuratorDesign.body(16),
            decoration: InputDecoration(
              icon: Icon(icon, color: CuratorDesign.primaryOrange, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter $label',
              hintStyle: CuratorDesign.body(14, color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(String title, String subtitle, IconData icon) {
    bool isSelected = _selectedPayment == title;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedPayment = title);
      },
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? CuratorDesign.primaryOrange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? CuratorDesign.primaryOrange : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? CuratorDesign.primaryOrange.withOpacity(0.2) : CuratorDesign.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? CuratorDesign.primaryOrange : Colors.black26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: CuratorDesign.label(14, color: isSelected ? CuratorDesign.primaryOrange : CuratorDesign.textDark)),
                  Text(subtitle, style: CuratorDesign.body(12, color: Colors.black38)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: CuratorDesign.primaryOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CuratorDesign.label(10, color: CuratorDesign.primaryOrange).copyWith(letterSpacing: 2)),
          const SizedBox(height: 4),
          Text(value, style: CuratorDesign.body(16, color: CuratorDesign.textDark)),
        ],
      ),
    );
  }

  Widget _buildGlassBottomBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: const Border(top: BorderSide(color: Colors.black12, width: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentStep == 2) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL PAYMENT', style: CuratorDesign.label(12)),
                    Text('₹${context.read<CartProvider>().total.toInt()}', style: CuratorDesign.display(24)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              DeepHeatButton(
                text: _currentStep == 2 ? 'CONFIRM ORDER' : 'CONTINUE',
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (_currentStep == 2) {
                    _completeOrder();
                  } else {
                    _nextStep();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, duration: 600.ms, curve: Curves.easeOutQuart);
  }
}
