import '../../core/network/api_client.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductRepository {
  /// Fetches all products from the backend
  Future<List<Product>> getProducts() async {
    final data = await ApiClient.get("/Product/GetAllProdutcs");

    if (data is List) {
      return data.map((item) => Product.fromJson(item)).toList();
    }
    return [];
  }

  /// Fetches all categories from the backend
  Future<List<Category>> getCategories() async {
    final data = await ApiClient.get("/Product/GetAllCategories");

    if (data is List) {
      return data.map((item) => Category.fromJson(item)).toList();
    }
    return [];
  }
}
