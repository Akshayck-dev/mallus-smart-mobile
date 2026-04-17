/// Demo sellers for products from the external API that have no seller data.
/// In production, seller data comes from your backend.
const _demoSellers = [
  {"id": "101", "name": "Anil Store – Thrissur", "phone": "919876543210"},
  {"id": "102", "name": "Sathyan Traders – Calicut", "phone": "919745612300"},
  {"id": "103", "name": "Kerala Organics – Palakkad", "phone": "919633445566"},
  {"id": "104", "name": "Malabar Fresh – Kannur", "phone": "919847119922"},
];

class Product {
  final String id;
  final String name;
  final String category;
  final int categoryId; // 🔥 New field for backend matching
  final double price;
  final String imageUrl;
  final String description;
  final List<String> gallery;
  final double stars;
  final int reviewCount;

  // 🔥 Seller info — always available (demo fallback injected if missing from API)
  final Map<String, dynamic> seller;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId = 0,
    required this.price,
    required this.imageUrl,
    required this.description,
    List<String>? gallery,
    this.stars = 4.5,
    this.reviewCount = 0,
    Map<String, dynamic>? seller,
  })  : gallery = gallery ?? [imageUrl],
        // Assign demo seller based on product id hash if none provided
        seller = seller ??
            _demoSellers[
                int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '0'))! %
                    _demoSellers.length];

  // Quick accessor helpers
  String get sellerName => seller['name'] ?? 'Unknown Seller';
  String get sellerPhone => seller['phone'] ?? '';
  String get sellerId => seller['id']?.toString() ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'categoryId': categoryId,
        'price': price,
        'imageUrl': imageUrl,
        'gallery': gallery,
        'description': description,
        'stars': stars,
        'reviewCount': reviewCount,
        'seller': seller, 
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'].toString();

    // 🔥 RESOLVE SELLER: Try to use backend member data, fallback to demo if missing
    Map<String, dynamic> resolvedSeller(String id) {
      final name = json['memberName'] ?? json['seller']?['name'];
      final memberId = json['memberID']?.toString() ?? json['seller']?['id']?.toString();
      
      if (name != null) {
        return {
          "id": memberId ?? "0",
          "name": name,
          "phone": "919000000000", // Generic if missing, seller logic needs phone for WhatsApp
        };
      }
      
      final n = int.tryParse(id.replaceAll(RegExp(r'[^0-9]'), '0')) ?? 0;
      return _demoSellers[n % _demoSellers.length];
    }

    // 🔥 MAP FIELDS: Supporting MalluSmart Backend (productName, categoryName, etc) 
    // and maintaining Legacy formats.
    return Product(
      id: rawId,
      name: json['productName'] ?? json['name'] ?? 'Undefined',
      category: json['categoryName'] ?? json['category'] ?? 'General',
      categoryId: json['categoryID'] ?? json['categoryId'] ?? 0,
      price: json.containsKey('priceCents') 
          ? (json['priceCents'] ?? 0) / 100.0 
          : (json['price'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      stars: (json['stars'] ?? json['rating']?['stars'] ?? 4.5).toDouble(),
      reviewCount: json['reviewCount'] ?? json['rating']?['count'] ?? 0,
      gallery: json['gallery'] != null ? List<String>.from(json['gallery']) : null,
      seller: resolvedSeller(rawId),
    );
  }
}
