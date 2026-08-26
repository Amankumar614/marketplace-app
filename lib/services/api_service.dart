import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/property.dart';
import '../models/interest.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String baseUrl =
      'https://marketplace-backend-6yhj.onrender.com/api';

  // ============================================================
  // LOGIN
  // ============================================================

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return User.fromJson(Map<String, dynamic>.from(data['user']));
    }

    throw Exception(data['message'] ?? 'Login failed');
  }

  // ============================================================
  // PROPERTIES
  // ============================================================

  Future<List<Property>> getProperties({
    String search = '',
    String location = '',
    String type = '',
    String status = '',
    int? minPrice,
    int? maxPrice,
    int? minArea,
    int? maxArea,
    int? rooms,
  }) async {
    final Map<String, String> params = {};

    if (search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    if (location.trim().isNotEmpty) {
      params['location'] = location.trim();
    }

    if (type.trim().isNotEmpty) {
      params['type'] = type.trim();
    }

    if (status.trim().isNotEmpty) {
      params['status'] = status.trim();
    }

    if (minPrice != null) {
      params['minPrice'] = minPrice.toString();
    }

    if (maxPrice != null) {
      params['maxPrice'] = maxPrice.toString();
    }

    if (minArea != null) {
      params['minArea'] = minArea.toString();
    }

    if (maxArea != null) {
      params['maxArea'] = maxArea.toString();
    }

    if (rooms != null) {
      params['rooms'] = rooms.toString();
    }

    final uri = Uri.parse(
      '$baseUrl/properties',
    ).replace(queryParameters: params.isEmpty ? null : params);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Property.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Failed to load properties');
  }

  // ============================================================
  // SINGLE PROPERTY
  // ============================================================

  Future<Property> getPropertyById(String propertyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/properties/$propertyId'),
    );

    if (response.statusCode == 200) {
      return Property.fromJson(
        Map<String, dynamic>.from(jsonDecode(response.body)),
      );
    }

    throw Exception('Failed to load property');
  }

  // ============================================================
  // SUBMIT INTEREST
  // ============================================================

  Future<dynamic> submitInterest({
    required String fullName,
    required String mobile,
    required String email,
    required String message,
    required String propertyId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interests'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'mobile': mobile,
        'email': email,
        'message': message,
        'propertyId': propertyId,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final data = jsonDecode(response.body);

    throw Exception(data['message'] ?? 'Failed to submit interest');
  }

  // ============================================================
  // OWNER PROPERTIES
  // ============================================================

  Future<List<Property>> getOwnerProperties(String ownerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/properties/owner/$ownerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Property.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Failed to load owner properties');
  }

  // ============================================================
  // OWNER INTERESTS
  // ============================================================

  Future<List<Interest>> getOwnerInterests(String ownerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/interests/owner/$ownerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Interest.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Failed to load owner interests');
  }

  // ============================================================
  // OLD METHODS
  // ============================================================
  // These are kept temporarily so your existing screens don't
  // immediately break while we migrate Listing -> Property.
  //
  // Remove them later once listing_screen.dart and the old
  // interest screen are fully migrated.
  // ============================================================

  Future<List<dynamic>> getListings() async {
    final response = await http.get(Uri.parse('$baseUrl/listings'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load listings');
  }

  Future<dynamic> getListingById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/listings/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load listing');
  }

  Future<List<dynamic>> getInterests() async {
    final response = await http.get(Uri.parse('$baseUrl/interests'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load interests');
  }
}
