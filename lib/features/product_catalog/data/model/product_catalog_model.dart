class ProductCatalogModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double raiting;
  final double discountPercentage;
  final String brand;
  final List<String> images;

  ProductCatalogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.raiting,
    required this.discountPercentage,
    required this.brand,
    required this.images,
  });

  factory ProductCatalogModel.fromJson(Map<String, dynamic> json) {
    return ProductCatalogModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      raiting: json['rating'],
      discountPercentage: json['discountPercentage'],
      brand: json['brand'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'raiting': raiting,
    'discountPercentage': discountPercentage,
    'brand': brand,
    'images': images,
  };
}
