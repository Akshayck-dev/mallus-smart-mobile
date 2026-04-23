import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/product.dart';
import '../data/models/category.dart';
import '../data/repositories/product_repository.dart';
import '../core/network/auth_service.dart';

class ProductProvider with ChangeNotifier {
  final _repo = ProductRepository();
  
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _syncTimer;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    _loadInitialData();
    startSync();
  }

  /// 📥 INITIAL LOAD (API based)
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    // 🚀 NO LOGIN: Skipping token generation as per request.
    // The APIs now allow guest access.

    await syncApiToFirebase();

    _isLoading = false;
    notifyListeners();
  }

  /// 🔄 PUBLIC SYNC (For Manual Refresh)
  Future<void> syncApiToFirebase() async {
    await Future.wait([
      _loadProducts(),
      _loadCategories(),
    ]);
    notifyListeners();
  }

  /// 📦 FETCH PRODUCTS FROM API
  Future<void> _loadProducts() async {
    try {
      final fetchedProducts = await _repo.getProducts();
      if (fetchedProducts.isNotEmpty) {
        _products = fetchedProducts;
        _errorMessage = null;
      }
    } catch (e) {
      print("❌ Product API Load Error: $e");
      _errorMessage = "Unable to refresh products. Please check your connection.";
    }
  }

  /// 📁 FETCH CATEGORIES FROM API
  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await _repo.getCategories();
      if (fetchedCategories.isNotEmpty) {
        _categories = fetchedCategories;
      }
    } catch (e) {
      print("❌ Category API Load Error: $e");
    }
  }

  /// 🔄 PERIODIC API REFRESH (Replaces Firestore sync)
  void startSync() {
    _syncTimer?.cancel();
    
    // Refresh every 30 seconds
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      print("🔄 Refreshing products from API...");
      await _loadProducts();
      notifyListeners();
    });
  }

  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// 🧩 CATEGORY HELPER: Resolves category ID to Name
  String getCategoryName(int id) {
    try {
      return _categories
          .firstWhere((c) => c.id == id)
          .name;
    } catch (_) {
      return "General";
    }
  }

  List<Product> getByCategory(String category) {
    if (category == 'All') return _products;
    return _products.where((p) => 
      p.category.toLowerCase().contains(category.toLowerCase()) ||
      getCategoryName(p.categoryId).toLowerCase().contains(category.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
