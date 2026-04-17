import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // 🔥 ADD ITEM
  void addItem(Map product) {
    final index =
        _items.indexWhere((item) => item.product["id"] == product["id"]);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  // ❌ REMOVE ITEM
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // 🔢 INCREASE
  void increaseQty(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // 🔢 DECREASE
  void decreaseQty(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  // 💰 TOTAL
  double get total {
    return _items.fold(
      0,
      (sum, item) =>
          sum + ((item.product["price"] as num).toDouble() * item.quantity),
    );
  }

  // 🧹 CLEAR
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
