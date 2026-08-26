// import 'package:flutter/material.dart';

// import '../models/listing.dart';
// import '../services/api_service.dart';
// import '../widgets/listing_card.dart';
// import 'listing_detail_screen.dart';
// import 'interests_screen.dart';

// class ListingScreen extends StatefulWidget {
//   const ListingScreen({super.key});

//   @override
//   State<ListingScreen> createState() => _ListingScreenState();
// }

// class _ListingScreenState extends State<ListingScreen> {
//   final ApiService apiService = ApiService();

//   bool isLoading = true;
//   String? errorMessage;

//   // Original data from API
//   List<Listing> listings = [];

//   // Filtered data shown on screen
//   List<Listing> filteredListings = [];

//   // Selected filters
//   String? selectedCategory;
//   String? selectedAreaCode;

//   // Price filter controllers
//   final TextEditingController minPriceController = TextEditingController();

//   final TextEditingController maxPriceController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadListings();
//   }

//   @override
//   void dispose() {
//     minPriceController.dispose();
//     maxPriceController.dispose();
//     super.dispose();
//   }

//   Future<void> loadListings() async {
//     try {
//       final data = await apiService.getListings();

//       final loadedListings =
//           data
//               .map((item) => Listing.fromJson(Map<String, dynamic>.from(item)))
//               .toList();

//       if (!mounted) return;

//       setState(() {
//         listings = loadedListings;
//         filteredListings = loadedListings;
//         isLoading = false;
//         errorMessage = null;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isLoading = false;
//         errorMessage = e.toString();
//       });
//     }
//   }

//   void applyFilters() {
//     final minPrice = double.tryParse(minPriceController.text.trim());

//     final maxPrice = double.tryParse(maxPriceController.text.trim());

//     setState(() {
//       filteredListings =
//           listings.where((listing) {
//             // Category filter
//             final categoryMatches =
//                 selectedCategory == null ||
//                 selectedCategory!.isEmpty ||
//                 listing.category == selectedCategory;

//             // Area code filter
//             final areaCodeMatches =
//                 selectedAreaCode == null ||
//                 selectedAreaCode!.isEmpty ||
//                 listing.areaCode == selectedAreaCode;

//             // Minimum price filter
//             final minPriceMatches =
//                 minPrice == null || listing.price >= minPrice;

//             // Maximum price filter
//             final maxPriceMatches =
//                 maxPrice == null || listing.price <= maxPrice;

//             return categoryMatches &&
//                 areaCodeMatches &&
//                 minPriceMatches &&
//                 maxPriceMatches;
//           }).toList();
//     });
//   }

//   void resetFilters() {
//     setState(() {
//       selectedCategory = null;
//       selectedAreaCode = null;

//       minPriceController.clear();
//       maxPriceController.clear();

//       filteredListings = List.from(listings);
//     });
//   }

//   List<String> get categories {
//     return listings.map((listing) => listing.category).toSet().toList();
//   }

//   List<String> get areaCodes {
//     return listings.map((listing) => listing.areaCode).toSet().toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Marketplace'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border),
//             tooltip: 'My Interests',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const InterestsScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: buildBody(),
//     );
//   }

//   Widget buildBody() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (errorMessage != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(errorMessage!, textAlign: TextAlign.center),
//         ),
//       );
//     }

//     return Column(children: [buildFilters(), Expanded(child: buildListings())]);
//   }

//   Widget buildFilters() {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Filters',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             // Category
//             DropdownButtonFormField<String>(
//               value: selectedCategory,
//               decoration: const InputDecoration(
//                 labelText: 'Category',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<String>(
//                   value: null,
//                   child: Text('All Categories'),
//                 ),
//                 ...categories.map(
//                   (category) => DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   ),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedCategory = value;
//                 });

//                 applyFilters();
//               },
//             ),

//             const SizedBox(height: 12),

//             // Area code
//             DropdownButtonFormField<String>(
//               value: selectedAreaCode,
//               decoration: const InputDecoration(
//                 labelText: 'Area Code',
//                 border: OutlineInputBorder(),
//               ),
//               items: [
//                 const DropdownMenuItem<String>(
//                   value: null,
//                   child: Text('All Area Codes'),
//                 ),
//                 ...areaCodes.map(
//                   (areaCode) => DropdownMenuItem<String>(
//                     value: areaCode,
//                     child: Text(areaCode),
//                   ),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedAreaCode = value;
//                 });

//                 applyFilters();
//               },
//             ),

//             const SizedBox(height: 12),

//             // Price range
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: minPriceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Min Price',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (_) {
//                       applyFilters();
//                     },
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: TextField(
//                     controller: maxPriceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Max Price',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (_) {
//                       applyFilters();
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // Reset button
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: resetFilters,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Reset Filters'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildListings() {
//     if (filteredListings.isEmpty) {
//       return const Center(
//         child: Text(
//           'No listings match your filters.',
//           style: TextStyle(fontSize: 16),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: loadListings,
//       child: ListView.builder(
//         padding: const EdgeInsets.only(bottom: 16),
//         itemCount: filteredListings.length,
//         itemBuilder: (context, index) {
//           final listing = filteredListings[index];

//           return ListingCard(
//             listing: listing,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ListingDetailScreen(listing: listing),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/property.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'interests_screen.dart';
import 'listing_detail_screen.dart';
import 'login_screen.dart';

class ListingScreen extends StatefulWidget {
  final User user;

  const ListingScreen({super.key, required this.user});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  String? errorMessage;

  List<Property> properties = [];
  List<Property> filteredProperties = [];

  // Search
  final TextEditingController searchController = TextEditingController();

  // Price
  final TextEditingController minPriceController = TextEditingController();

  final TextEditingController maxPriceController = TextEditingController();

  // Area
  final TextEditingController minAreaController = TextEditingController();

  final TextEditingController maxAreaController = TextEditingController();

  // Filters
  String? selectedLocation;
  String? selectedType;
  String? selectedStatus;
  int? selectedRooms;

  @override
  void initState() {
    super.initState();
    loadProperties();
  }

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    minAreaController.dispose();
    maxAreaController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD PROPERTIES
  // ============================================================

  Future<void> loadProperties() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedProperties = await apiService.getProperties();

      if (!mounted) return;

      setState(() {
        properties = loadedProperties;
        filteredProperties = List.from(loadedProperties);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // FILTERS
  // ============================================================

  void applyFilters() {
    final search = searchController.text.trim().toLowerCase();

    final minPrice = double.tryParse(minPriceController.text.trim());

    final maxPrice = double.tryParse(maxPriceController.text.trim());

    final minArea = double.tryParse(minAreaController.text.trim());

    final maxArea = double.tryParse(maxAreaController.text.trim());

    setState(() {
      filteredProperties =
          properties.where((property) {
            // Search
            final searchMatches =
                search.isEmpty ||
                property.name.toLowerCase().contains(search) ||
                property.location.toLowerCase().contains(search) ||
                property.type.toLowerCase().contains(search);

            // Location
            final locationMatches =
                selectedLocation == null ||
                property.location == selectedLocation;

            // Type
            final typeMatches =
                selectedType == null || property.type == selectedType;

            // Status
            final statusMatches =
                selectedStatus == null || property.status == selectedStatus;

            // Rooms
            final roomsMatches =
                selectedRooms == null || property.rooms == selectedRooms;

            // Minimum price
            final minPriceMatches =
                minPrice == null || property.price >= minPrice;

            // Maximum price
            final maxPriceMatches =
                maxPrice == null || property.price <= maxPrice;

            // Minimum area
            final minAreaMatches = minArea == null || property.area >= minArea;

            // Maximum area
            final maxAreaMatches = maxArea == null || property.area <= maxArea;

            return searchMatches &&
                locationMatches &&
                typeMatches &&
                statusMatches &&
                roomsMatches &&
                minPriceMatches &&
                maxPriceMatches &&
                minAreaMatches &&
                maxAreaMatches;
          }).toList();
    });
  }

  // ============================================================
  // RESET
  // ============================================================

  void resetFilters() {
    searchController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    minAreaController.clear();
    maxAreaController.clear();

    setState(() {
      selectedLocation = null;
      selectedType = null;
      selectedStatus = null;
      selectedRooms = null;

      filteredProperties = List.from(properties);
    });
  }

  // ============================================================
  // FILTER OPTIONS
  // ============================================================

  List<String> get locations {
    return properties
        .map((property) => property.location)
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get propertyTypes {
    return properties
        .map((property) => property.type)
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get statuses {
    return properties
        .map((property) => property.status)
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<int> get roomOptions {
    return properties
        .map((property) => property.rooms)
        .where((value) => value > 0)
        .toSet()
        .toList()
      ..sort();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'My Interests',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InterestsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 50),
              const SizedBox(height: 12),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadProperties,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        buildWelcomeSection(),
        buildFilters(),
        Expanded(child: buildProperties()),
      ],
    );
  }

  // ============================================================
  // WELCOME
  // ============================================================

  Widget buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Find your next property',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER UI
  // ============================================================

  Widget buildFilters() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ExpansionTile(
        title: const Text(
          'Search & Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.filter_alt_outlined),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                // SEARCH
                TextField(
                  controller: searchController,
                  onChanged: (_) {
                    applyFilters();
                  },
                  decoration: InputDecoration(
                    labelText: 'Search property or location',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                applyFilters();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            )
                            : null,
                  ),
                ),

                const SizedBox(height: 12),

                // LOCATION
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('All Locations'),
                  items:
                      locations
                          .map(
                            (location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                    applyFilters();
                  },
                ),

                const SizedBox(height: 12),

                // PROPERTY TYPE
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('All Property Types'),
                  items:
                      propertyTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                    applyFilters();
                  },
                ),

                const SizedBox(height: 12),

                // STATUS
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('All Statuses'),
                  items:
                      statuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                    applyFilters();
                  },
                ),

                const SizedBox(height: 12),

                // ROOMS
                DropdownButtonFormField<int>(
                  value: selectedRooms,
                  decoration: const InputDecoration(
                    labelText: 'Configuration / Rooms',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('All Configurations'),
                  items:
                      roomOptions
                          .map(
                            (rooms) => DropdownMenuItem(
                              value: rooms,
                              child: Text('$rooms BHK'),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRooms = value;
                    });
                    applyFilters();
                  },
                ),

                const SizedBox(height: 12),

                // PRICE
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          applyFilters();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          applyFilters();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // AREA
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minAreaController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          applyFilters();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Min Area (sq.ft)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: maxAreaController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) {
                          applyFilters();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Max Area (sq.ft)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // RESET
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
        ],
      ),
    );
  }

  // ============================================================
  // PROPERTY LIST
  // ============================================================

  Widget buildProperties() {
    if (filteredProperties.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadProperties,
        child: ListView(
          children: const [
            SizedBox(height: 150),
            Center(
              child: Text(
                'No properties match your filters.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadProperties,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
        itemCount: filteredProperties.length,
        itemBuilder: (context, index) {
          final property = filteredProperties[index];

          return buildPropertyCard(property);
        },
      ),
    );
  }

  // ============================================================
  // PROPERTY CARD
  // ============================================================

  Widget buildPropertyCard(Property property) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListingDetailScreen(property: property),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE PLACEHOLDER
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.home_work_outlined,
                    size: 55,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // NAME
              Text(
                property.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // LOCATION
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Expanded(child: Text(property.location)),
                ],
              ),

              const SizedBox(height: 10),

              // PRICE
              Text(
                '₹${property.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // DETAILS
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _infoChip(Icons.home_outlined, property.type),
                  _infoChip(
                    Icons.square_foot,
                    '${property.area.toStringAsFixed(0)} sq.ft',
                  ),
                  _infoChip(Icons.bed_outlined, '${property.rooms} BHK'),
                  _infoChip(Icons.info_outline, property.status),
                ],
              ),

              const SizedBox(height: 12),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View Details →',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 15), const SizedBox(width: 4), Text(text)],
      ),
    );
  }
}
