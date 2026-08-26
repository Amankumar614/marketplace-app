class Interest {
  final String id;
  final String fullName;
  final String mobile;
  final String email;
  final String message;
  final String propertyId;
  final String propertyName;
  final String status;

  const Interest({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.message,
    required this.propertyId,
    required this.propertyName,
    required this.status,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    final property = json['propertyId'];

    return Interest(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      propertyId:
          property is Map
              ? property['_id']?.toString() ?? ''
              : property?.toString() ?? '',
      propertyName: property is Map ? property['name']?.toString() ?? '' : '',
      status: json['status']?.toString() ?? 'Pending',
    );
  }
}
