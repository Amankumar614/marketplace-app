import 'package:flutter/material.dart';
import '../models/listing.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onTap;

  const ListingCard({super.key, required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listing.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text('Category: ${listing.category}'),

              const SizedBox(height: 4),

              Text('Area Code: ${listing.areaCode}'),

              const SizedBox(height: 4),

              Text('Price: ₹${listing.price.toStringAsFixed(0)}'),

              const SizedBox(height: 4),

              Text('Status: ${listing.status}'),
            ],
          ),
        ),
      ),
    );
  }
}
