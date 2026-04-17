import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:mallu_smart/widgets/app_button.dart';
import 'package:mallu_smart/widgets/interactive/bounceable.dart';
import 'package:mallu_smart/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'checkout_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedState = 'Kerala';
  bool _isDefault = false;

  final List<String> _states = [
    'Kerala', 'Tamil Nadu', 'Karnataka', 'Maharashtra', 'Delhi', 'Telangana', 'Gujarat'
  ];

  final _nameController = TextEditingController(text: 'Akshay Kumar');
  final _phoneController = TextEditingController(text: '+91 ');
  final _streetController = TextEditingController(text: 'MG Road, Marine Drive');
  final _cityController = TextEditingController(text: 'Kochi');
  final _zipController = TextEditingController(text: '682001');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: CuratorDesign.surfaceColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Shipping Info',
                        style: CuratorDesign.display(28, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Provide your shipping details for a seamless boutique delivery experience.',
                        style: CuratorDesign.body(14, color: CuratorDesign.textLight).copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 32),

                      _buildFieldLabel('FULL NAME', isDark),
                      _buildTextField(_nameController, 'Full Name', isDark),
                      
                      const SizedBox(height: 24),
                      _buildFieldLabel('PHONE NUMBER', isDark),
                      _buildTextField(_phoneController, 'Phone Number', isDark, keyboardType: TextInputType.phone),
                      
                      const SizedBox(height: 24),
                      _buildFieldLabel('STREET ADDRESS', isDark),
                      _buildTextField(_streetController, 'Street Address', isDark),
                      
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('CITY', isDark),
                                _buildTextField(_cityController, 'City', isDark),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('STATE', isDark),
                                _buildStateDropdown(isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      _buildFieldLabel('PIN CODE', isDark),
                      _buildTextField(_zipController, 'PIN Code', isDark, keyboardType: TextInputType.number),
                      
                      const SizedBox(height: 32),
                      
                      Bounceable(
                        onTap: () => setState(() => _isDefault = !_isDefault),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _isDefault ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
                                  border: Border.all(
                                    color: _isDefault ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white38 : Colors.black26),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: _isDefault 
                                  ? Icon(Icons.check, size: 14, color: isDark ? Colors.black : Colors.white)
                                  : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Set as default shipping address',
                                style: CuratorDesign.label(13, weight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      AppButton(
                        text: 'CONTINUE TO REVIEW',
                        height: 60,
                        colors: [isDark ? Colors.white : Colors.black],
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            HapticFeedback.heavyImpact();
                            final cart = context.read<CartProvider>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  cartItems: cart.items,
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.arrow_forward_rounded, color: isDark ? Colors.black : Colors.white, size: 20),
                      ),
                      
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleAction(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
            isDark: isDark,
          ),
          Text(
            'Shipping',
            style: CuratorDesign.label(16, weight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: CuratorDesign.label(10, weight: FontWeight.w800, color: CuratorDesign.textLight)
            .copyWith(letterSpacing: 2),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isDark, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: CuratorDesign.body(14, weight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
        validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: CuratorDesign.body(14, color: CuratorDesign.textLight),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildStateDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedState,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          icon: Icon(Icons.expand_more_rounded, color: isDark ? Colors.white38 : Colors.black26),
          style: CuratorDesign.body(14, weight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
          onChanged: (String? newValue) {
            setState(() {
              _selectedState = newValue!;
            });
          },
          items: _states.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _CircleAction({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFF0F0F0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 20),
      ),
    );
  }
}
