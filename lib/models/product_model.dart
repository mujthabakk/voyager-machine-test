class Product {
  final String id;
  final String productCode;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String category;
  final DateTime createdAt;
  final String createdBy;

  Product({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.createdBy,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      productCode: map['productCode'] ?? '',
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'],
      category: map['category'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productCode': productCode,
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  Product copyWith({
    String? id,
    String? productCode,
    String? productName,
    String? description,
    double? price,
    int? quantity,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Product(
      id: id ?? this.id,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
