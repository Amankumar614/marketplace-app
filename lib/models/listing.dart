class Listing {
  final String id;
  final String title;
  final String category;
  final String areaCode;
  final double price;
  final String status;
  final String description;

  Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.areaCode,
    required this.price,
    required this.status,
    required this.description,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      areaCode: json['areaCode'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
