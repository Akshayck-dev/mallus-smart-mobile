import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mallu_smart/data/models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://kolzsticks.github.io/Free-Ecommerce-Products-Api/main/products.json';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Product>> fetchProductsPaged({int page = 1, int limit = 10, String? category}) async {
    // Basic shim for demo API that doesn't natively support paging
    final service = ProductService();
    final all = await service.fetchProducts();
    
    List<Product> filtered = all;
    if (category != null && category.isNotEmpty) {
      filtered = all.where((p) => p.category.toUpperCase() == category.toUpperCase()).toList();
    }
    
    final start = (page - 1) * limit;
    if (start >= filtered.length) return [];
    
    final end = (start + limit) > filtered.length ? filtered.length : (start + limit);
    return filtered.sublist(start, end);
  }
}
