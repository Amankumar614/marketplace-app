import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../services/api_service.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;

  const ListingDetailScreen({super.key, required this.listing});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final ApiService apiService = ApiService();

  bool isSubmitting = false;

  Future<void> submitInterest() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      await apiService.submitInterest(widget.listing.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interest submitted successfully. Status: Pending'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit interest: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;

    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listing.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            _buildDetail('Category', listing.category),

            _buildDetail('Area Code', listing.areaCode),

            _buildDetail('Price', '₹${listing.price.toStringAsFixed(0)}'),

            _buildDetail('Status', listing.status),

            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              listing.description.isEmpty
                  ? 'No description available.'
                  : listing.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Seller contact intentionally hidden.
            const Text(
              'Seller Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Seller contact information is hidden.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitInterest,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child:
                      isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(
                            'Submit Interest',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
