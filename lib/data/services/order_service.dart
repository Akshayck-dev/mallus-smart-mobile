import 'package:url_launcher/url_launcher.dart';
import 'package:mallu_smart/data/models/cart_item.dart';

/// ─────────────────────────────────────────────────────────────────
/// OrderService
///
/// Handles the complete multi-seller order flow:
///   1. Group cart items by seller phone
///   2. Build a WhatsApp message per seller
///   3. Launch WhatsApp for each seller
///   4. Save order locally (swap saveOrderLocally → ApiService.saveOrder later)
/// ─────────────────────────────────────────────────────────────────

class OrderService {
  // 📦 In-memory local order store (demo mode)
  // Replace with SQLite / Hive / API call in production
  static final List<Map<String, dynamic>> _orders = [];

  /// Returns read-only copy of saved orders
  static List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  // ── STEP 2: Group cart items by seller phone ─────────────────────
  static Map<String, List<CartItem>> groupBySeller(List<CartItem> cartItems) {
    final Map<String, List<CartItem>> grouped = {};

    for (final item in cartItems) {
      final seller = item.product['seller'];
      final phone =
          (seller is Map ? seller['phone'] : null) as String? ?? '0000000000';

      grouped.putIfAbsent(phone, () => []).add(item);
    }

    return grouped;
  }

  // ── STEP 3: Build WhatsApp message per seller ────────────────────
  static String buildSellerMessage({
    required String sellerName,
    required List<CartItem> items,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('🛒 *New Order — Mallu Smart*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('');
    buffer.writeln('*Customer:* $customerName');
    if (customerPhone.isNotEmpty) buffer.writeln('*Phone:* $customerPhone');
    buffer.writeln('*Address:* $customerAddress');
    buffer.writeln('');
    buffer.writeln('📦 *Items:*');

    double sellerTotal = 0;
    for (final item in items) {
      final name = item.product['name'] ?? 'Product';
      final price = (item.product['price'] as num).toDouble();
      final qty = item.quantity;
      final lineTotal = price * qty;
      sellerTotal += lineTotal;
      buffer.writeln('• $name × $qty = ₹${lineTotal.toStringAsFixed(0)}');
    }

    buffer.writeln('');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('*Total: ₹${sellerTotal.toStringAsFixed(0)}*');
    buffer.writeln('');
    buffer.writeln(
        'Please confirm availability and delivery timeline. Thank you! 🙏');

    return buffer.toString();
  }

  // ── WhatsApp launcher helper ─────────────────────────────────────
  static Future<bool> sendToWhatsApp(String phone, String message) async {
    // Ensure phone has country code, no +/spaces
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final encoded = Uri.encodeComponent(message);
    final waUrl = Uri.parse('https://wa.me/$cleanPhone?text=$encoded');

    if (await canLaunchUrl(waUrl)) {
      return launchUrl(waUrl, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  // ── STEP 4: Send WhatsApp per seller ────────────────────────────
  static Future<void> sendOrders({
    required List<CartItem> cartItems,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    final grouped = groupBySeller(cartItems);

    for (final entry in grouped.entries) {
      final phone = entry.key;
      final sellerItems = entry.value;

      // Get seller name from first item
      final seller = sellerItems.first.product['seller'];
      final sellerName =
          (seller is Map ? seller['name'] : null) as String? ?? 'Seller';

      final message = buildSellerMessage(
        sellerName: sellerName,
        items: sellerItems,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
      );

      await sendToWhatsApp(phone, message);

      // Small delay between multiple WhatsApp launches
      if (grouped.length > 1) {
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
  }

  // ── STEP 5–6: Save order locally (demo mode) ─────────────────────
  static void saveOrderLocally(Map<String, dynamic> order) {
    _orders.insert(0, {
      ...order,
      'id': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'confirmed',
    });
  }

  // ── STEP 7: API-ready wrapper (swap this in production) ──────────
  static Future<void> placeOrder({
    required List<CartItem> cartItems,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    String customerEmail = '',
  }) async {
    // Build order payload
    final order = <String, dynamic>{
      'user': {
        'name': customerName,
        'phone': customerPhone,
        'email': customerEmail,
        'address': customerAddress,
      },
      'items': cartItems
          .map((item) => {
                'product': item.product,
                'quantity': item.quantity,
                'seller': item.product['seller'],
              })
          .toList(),
      'sellerGroups': groupBySeller(cartItems).map(
        (phone, items) => MapEntry(phone, {
          'sellerPhone': phone,
          'sellerName': (items.first.product['seller'] is Map
              ? items.first.product['seller']['name']
              : 'Seller') as String?,
          'items': items
              .map((i) => {'name': i.product['name'], 'qty': i.quantity})
              .toList(),
        }),
      ),
      'total': cartItems.fold<double>(
          0,
          (sum, item) =>
              sum + (item.product['price'] as num).toDouble() * item.quantity),
      'date': DateTime.now().toIso8601String(),
    };

    // 💾 SAVE LOCALLY (replace with: await ApiService.saveOrder(order))
    saveOrderLocally(order);

    // 📲 SEND TO ALL SELLERS VIA WHATSAPP
    await sendOrders(
      cartItems: cartItems,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
    );
  }
}
