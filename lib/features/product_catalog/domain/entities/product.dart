class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double raiting;
  final double discountPercentage;
  final String brand;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.raiting,
    required this.discountPercentage,
    required this.brand,
    required this.images,
  });
}
