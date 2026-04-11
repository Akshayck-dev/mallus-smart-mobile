import 'package:mallu_smart/models/product.dart';
import 'package:mallu_smart/data/sample_data.dart';

class ProductService {
  /// Simulates a paged API call with a 1.5s delay
  static Future<List<Product>> fetchProductsPaged({
    required int page,
    required int limit,
    String category = 'ALL',
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Filter by category if needed
    final filtered = allProducts.where((p) {
      return category == 'ALL' || p.category.toUpperCase() == category.toUpperCase();
    }).toList();

    // Calculate start and end indices
    final int start = page * limit;
    
    // For demo purposes, if we run out of real products, we'll return an empty list 
    // to simulate the "end" of the data, unless the list is very small, 
    // then we'll loop it for a better visual demo.
    
    if (start >= filtered.length) {
      // Return empty if we genuinely reached the end of the "database"
      // In this demo, since we only have 6 items, let's limit it to 3 pages total
      if (page >= 3) return [];
      
      // Otherwise, just return the list again with unique IDs for demo
      return filtered.map((p) => Product(
        id: '${p.id}-p$page',
        name: '${p.name} (P$page)',
        category: p.category,
        price: p.price,
        imageUrl: p.imageUrl,
        description: p.description,
      )).toList();
    }

    final int end = (start + limit) > filtered.length ? filtered.length : (start + limit);
    return filtered.sublist(start, end);
  }
}
