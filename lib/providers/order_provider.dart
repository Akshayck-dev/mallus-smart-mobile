import 'package:flutter/material.dart';
import '../data/repositories/order_repository.dart';
import '../data/services/order_service.dart';
import '../data/models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final _repo = OrderRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Handles enterprise order fulfillment: API Sync + WhatsApp Notification
  Future<bool> placeOrder({
    required String name,
    required String address,
    required String mobile,
    required String email,
    required List<CartItem> cartItems,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Prepare simplified product list for backend sync
      final apiProducts = cartItems.map((item) => {
        "productId": int.tryParse(item.product['id'].toString()) ?? 0,
        "quantity": item.quantity,
      }).toList();

      // 2. 🔐 API Sync (Enterprise Backend)
      await _repo.placeOrder(
        name: name,
        address: address,
        mobile: mobile,
        email: email,
        products: apiProducts,
      );

      // 3. 📲 WHATSAPP FAIL SAFE (Seller Notification)
      // We wrap this in another try-catch so that if the user doesn't have 
      // WhatsApp installed, the order is still considered "placed" in our DB.
      try {
        await OrderService.sendOrders(
          cartItems: cartItems,
          customerName: name,
          customerPhone: mobile,
          customerAddress: address,
        );
      } catch (e) {
        print("⚠️ WhatsApp Fail-Safe Triggered: $e");
        // We continue because API success is primary for the business
      }

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("❌ Order Fulfillment Error: $e");
      return false;
    }
  }
}
