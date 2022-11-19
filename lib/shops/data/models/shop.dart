class Shop {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String address;
  final double lat;
  final double lng;
  final dynamic category;
  final dynamic reference;
  final bool isPopular;
  final String categoryName;
  final dynamic rating;
  final dynamic products;

  const Shop({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.address,
    required this.lat,
    required this.lng,
    required this.category,
    required this.reference,
    required this.isPopular,
    required this.categoryName,
    required this.rating,
    this.products
  });
}
