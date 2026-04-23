import '../../core/network/api_client.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductRepository {
  /// Fetches all products from the backend
  Future<List<Product>> getProducts() async {
    try {
      final data = await ApiClient.get("/Product/GetAllProdutcs");
      
      // 🔥 HANDLE WRAPPED RESPONSE: { "value": [...], "Count": N }
      List<dynamic> items = [];
      if (data is Map && data.containsKey('value')) {
        items = data['value'] as List<dynamic>;
      } else if (data is List) {
        items = data;
      }

      print("📦 API RAW DATA: Received ${items.length} potential products.");

      final products = <Product>[];
      for (var item in items) {
        try {
          products.add(Product.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print("⚠️ Skipping invalid product: $e");
        }
      }

      print("✅ PARSING SUCCESS: Successfully parsed ${products.length} products.");
      return products;
    } catch (e) {
      print("❌ REPOSITORY ERROR (getProducts): $e");
      rethrow;
    }
  }

  /// Fetches all categories from the backend
  Future<List<Category>> getCategories() async {
    try {
      final data = await ApiClient.get("/Product/GetAllCategories");

      List<dynamic> items = [];
      if (data is Map && data.containsKey('value')) {
        items = data['value'] as List<dynamic>;
      } else if (data is List) {
        items = data;
      }

      print("📂 API RAW DATA: Received ${items.length} categories.");

      final categories = <Category>[];
      for (var item in items) {
        try {
          categories.add(Category.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print("⚠️ Skipping invalid category: $e");
        }
      }
      
      return categories;
    } catch (e) {
      print("❌ REPOSITORY ERROR (getCategories): $e");
      rethrow;
    }
  }
}
