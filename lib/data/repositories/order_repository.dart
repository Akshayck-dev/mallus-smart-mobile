import 'dart:convert';
import '../../core/network/api_client.dart';

class OrderRepository {
  /// Syncs order details with the backend
  Future<bool> placeOrder({
    required String name,
    required String address,
    required String mobile,
    required String email,
    required List<Map<String, dynamic>> products,
  }) async {
    final body = {
      "customerName": name,
      "address": address,
      "mobile": mobile,
      "email": email,
      "createdOn": DateTime.now().toIso8601String(),
      "products": products,
    };

    // Logging the payload as requested for enterprise debugging
    print("ORDER SYNC PAYLOAD: ${jsonEncode(body)}");

    await ApiClient.post("/Product/SaveOrderDetails", body);

    return true;
  }
}
