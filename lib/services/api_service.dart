import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://marketplace-backend-6yhj.onrender.com/api';

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

  Future<dynamic> submitInterest(String listingId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interests'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'listingId': listingId}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to submit interest');
  }

  Future<List<dynamic>> getInterests() async {
    final response = await http.get(Uri.parse('$baseUrl/interests'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load interests');
  }

  Future<void> deleteAllInterests() async {
    final response = await http.delete(Uri.parse('$baseUrl/interests'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete interests');
    }
  }
}
