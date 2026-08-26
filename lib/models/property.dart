class Property {
  final String id;
  final String name;
  final String type;
  final String location;
  final double price;
  final double area;
  final int rooms;
  final String status;
  final String description;
  final String imagePlaceholder;
  final String ownerId;
  final String ownerName;

  const Property({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.price,
    required this.area,
    required this.rooms,
    required this.status,
    required this.description,
    required this.imagePlaceholder,
    required this.ownerId,
    required this.ownerName,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final owner = json['ownerId'];

    return Property(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0,
      rooms: (json['rooms'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imagePlaceholder: json['imagePlaceholder']?.toString() ?? '',
      ownerId:
          owner is Map
              ? owner['_id']?.toString() ?? ''
              : owner?.toString() ?? '',
      ownerName: owner is Map ? owner['name']?.toString() ?? '' : '',
    );
  }
}
