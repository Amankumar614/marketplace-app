import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../services/api_service.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';
import 'interests_screen.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  String? errorMessage;

  // Original data from API
  List<Listing> listings = [];

  // Filtered data shown on screen
  List<Listing> filteredListings = [];

  // Selected filters
  String? selectedCategory;
  String? selectedAreaCode;

  // Price filter controllers
  final TextEditingController minPriceController = TextEditingController();

  final TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadListings();
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  Future<void> loadListings() async {
    try {
      final data = await apiService.getListings();

      final loadedListings =
          data
              .map((item) => Listing.fromJson(Map<String, dynamic>.from(item)))
              .toList();

      if (!mounted) return;

      setState(() {
        listings = loadedListings;
        filteredListings = loadedListings;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void applyFilters() {
    final minPrice = double.tryParse(minPriceController.text.trim());

    final maxPrice = double.tryParse(maxPriceController.text.trim());

    setState(() {
      filteredListings =
          listings.where((listing) {
            // Category filter
            final categoryMatches =
                selectedCategory == null ||
                selectedCategory!.isEmpty ||
                listing.category == selectedCategory;

            // Area code filter
            final areaCodeMatches =
                selectedAreaCode == null ||
                selectedAreaCode!.isEmpty ||
                listing.areaCode == selectedAreaCode;

            // Minimum price filter
            final minPriceMatches =
                minPrice == null || listing.price >= minPrice;

            // Maximum price filter
            final maxPriceMatches =
                maxPrice == null || listing.price <= maxPrice;

            return categoryMatches &&
                areaCodeMatches &&
                minPriceMatches &&
                maxPriceMatches;
          }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedAreaCode = null;

      minPriceController.clear();
      maxPriceController.clear();

      filteredListings = List.from(listings);
    });
  }

  List<String> get categories {
    return listings.map((listing) => listing.category).toSet().toList();
  }

  List<String> get areaCodes {
    return listings.map((listing) => listing.areaCode).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'My Interests',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InterestsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    return Column(children: [buildFilters(), Expanded(child: buildListings())]);
  }

  Widget buildFilters() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...categories.map(
                  (category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });

                applyFilters();
              },
            ),

            const SizedBox(height: 12),

            // Area code
            DropdownButtonFormField<String>(
              value: selectedAreaCode,
              decoration: const InputDecoration(
                labelText: 'Area Code',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Area Codes'),
                ),
                ...areaCodes.map(
                  (areaCode) => DropdownMenuItem<String>(
                    value: areaCode,
                    child: Text(areaCode),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedAreaCode = value;
                });

                applyFilters();
              },
            ),

            const SizedBox(height: 12),

            // Price range
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      applyFilters();
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      applyFilters();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: resetFilters,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListings() {
    if (filteredListings.isEmpty) {
      return const Center(
        child: Text(
          'No listings match your filters.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadListings,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: filteredListings.length,
        itemBuilder: (context, index) {
          final listing = filteredListings[index];

          return ListingCard(
            listing: listing,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingDetailScreen(listing: listing),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
