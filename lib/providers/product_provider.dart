import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/product.dart';
import '../data/models/category.dart';
import '../data/repositories/product_repository.dart';
import '../data/sample_data.dart';

class ProductProvider with ChangeNotifier {
  final _repo = ProductRepository();
  final _firestore = FirebaseFirestore.instance;
  
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _syncTimer;
  StreamSubscription<QuerySnapshot>? _productSubscription;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    _startFirestoreListener();
    _loadCategories(); // Categories still fetched via API/Initial
    startSync();
  }

  /// 🛰️ REAL-TIME LISTENER: Firestore → UI
  void _startFirestoreListener() {
    try {
      _productSubscription?.cancel();
      _productSubscription = _firestore
          .collection('products')
          .snapshots()
          .listen((snapshot) {
        _products = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Ensure ID is included in data for the factory
          if (!data.containsKey('id')) data['id'] = doc.id;
          return Product.fromJson(data);
        }).toList();
        
        // Only fallback to demo data if absolutely necessary for first run
        // Disabling for "Real Data" mode
        /*
        if (_products.isEmpty) {
          _products = allProducts;
        }
        */
        
        notifyListeners();
      }, onError: (e) {
        print("❌ Firestore Listener Stream Error: $e");
        // if (_products.isEmpty) _products = allProducts;
        notifyListeners();
      });
    } catch (e) {
      print("❌ Firestore Listener Setup Error: $e");
      // if (_products.isEmpty) _products = allProducts;
      notifyListeners();
    }
  }

  /// 📦 CATEGORY INITIAL LOAD (API based)
  Future<void> _loadCategories() async {
    try {
      _categories = await _repo.getCategories();
      notifyListeners();
    } catch (e) {
      print("Category Load Error: $e");
    }
  }

  /// 🔄 API → FIREBASE SYNC (SMART UPSERT)
  Future<void> syncApiToFirebase() async {
    print("🚀 Starting API to Firebase Sync...");
    try {
      final apiProducts = await _repo.getProducts();
      
      for (var p in apiProducts) {
        final docRef = _firestore.collection('products').doc(p.id.toString());
        
        // 🧠 SMART UPSERT: Check if changed before writing
        final doc = await docRef.get();
        final newData = p.toJson();

        if (!doc.exists || doc.data().toString() != newData.toString()) {
          await docRef.set(newData);
          print("✅ Synced Product: ${p.name}");
        }
      }
    } catch (e) {
      print("⚠️ Sync Error: $e");
      _errorMessage = "Sync Error: $e";
      notifyListeners();
    }
  }

  /// ⏱️ SYNC TIMER MANAGEMENT (Memory Safe)
  void startSync() {
    _syncTimer?.cancel();
    
    // Initial sync
    syncApiToFirebase();
    
    // Periodic sync every 30 seconds
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      syncApiToFirebase();
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
    _productSubscription?.cancel();
    super.dispose();
  }
}
