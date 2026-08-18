class Interest {
  final String id;
  final String listingId;
  final String listingTitle;
  final String category;
  final String areaCode;
  final double price;
  final String status;
  final DateTime? createdAt;

  Interest({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.category,
    required this.areaCode,
    required this.price,
    required this.status,
    this.createdAt,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    final listingData = json['listingId'];

    if (listingData is Map) {
      return Interest(
        id: json['_id'] ?? '',
        listingId: listingData['_id'] ?? '',
        listingTitle: listingData['title'] ?? 'Unknown Listing',
        category: listingData['category'] ?? '',
        areaCode: listingData['areaCode'] ?? '',
        price: (listingData['price'] ?? 0).toDouble(),
        status: json['status'] ?? 'Pending',
        createdAt:
            json['createdAt'] != null
                ? DateTime.tryParse(json['createdAt'])
                : null,
      );
    }

    return Interest(
      id: json['_id'] ?? '',
      listingId: listingData ?? '',
      listingTitle: 'Unknown Listing',
      category: '',
      areaCode: '',
      price: 0,
      status: json['status'] ?? 'Pending',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }
}
