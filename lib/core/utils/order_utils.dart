import 'package:mallu_smart/data/models/cart_item.dart';

class OrderUtils {
  static String generateWhatsAppMessage({
    required List<CartItem> items,
    required double subtotal,
    required double tax,
    required double total,
    required String name,
    required String address,
    String? phone,
    String? promoCode,
    double? discount,
  }) {
    final StringBuffer buffer = StringBuffer();

    // Header
    buffer.writeln("I am interested to buy the following items from Mallu Smart:");
    buffer.writeln();
    buffer.writeln("🛍️ *NEW ORDER FROM MALLU SMART*");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("*Customer:* $name");
    if (phone != null && phone.isNotEmpty) buffer.writeln("*Phone:* $phone");
    buffer.writeln("*Date:* ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    buffer.writeln();

    // Items
    buffer.writeln("📦 *ITEMS:*");
    for (var item in items) {
      final price = (item.product["price"] as num).toDouble();
      final name = item.product["name"] ?? "Product";
      final itemTotal = price * item.quantity;
      buffer.writeln("• $name");
      buffer.writeln("  ${item.quantity}x @ ₹${price.toStringAsFixed(2)} = *₹${itemTotal.toStringAsFixed(2)}*");
    }
    buffer.writeln();

    // Summary
    buffer.writeln("💰 *SUMMARY:*");
    buffer.writeln("Subtotal: ₹${subtotal.toStringAsFixed(2)}");
    if (discount != null && discount > 0) {
      buffer.writeln("Discount (${promoCode ?? 'Promo'}): -₹${discount.toStringAsFixed(2)}");
    }
    buffer.writeln("Tax (5%): ₹${tax.toStringAsFixed(2)}");
    buffer.writeln("Shipping: *FREE*");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("*TOTAL PAYABLE: ₹${total.toStringAsFixed(2)}*");
    buffer.writeln();

    // Delivery
    buffer.writeln("📍 *DELIVERY ADDRESS:*");
    buffer.writeln(address);
    buffer.writeln();

    buffer.writeln("━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("Thank you for choosing Mallu Smart.");
    buffer.writeln("Please confirm this order to proceed.");

    return buffer.toString();
  }
}
