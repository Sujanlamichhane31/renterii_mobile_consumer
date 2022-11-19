class Rental {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String address;
  final double lat;
  final double lng;

  const Rental({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.address,
    required this.lat,
    required this.lng,
  });

  Rental.fromMap(Map<String, dynamic> map)
        :title = map['title'],
        description = map['description'],
        imageUrl = map['image'],
        price = map['price'],
        address = map['address'],
        lat = map['lat'],
        lng = map['lng'];

}