import 'package:flutter/material.dart';

import '../models/interest.dart';
import '../services/api_service.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  String? errorMessage;

  List<Interest> interests = [];

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  Future<void> loadInterests() async {
    try {
      final data = await apiService.getInterests();

      final loadedInterests =
          data
              .map((item) => Interest.fromJson(Map<String, dynamic>.from(item)))
              .toList();

      if (!mounted) return;

      setState(() {
        interests = loadedInterests;
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

  void showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete All Interests?'),
          content: const Text(
            'This will permanently delete all your submitted interests.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAllInterests();
              },
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Interests'),
        actions: [
          if (interests.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete All Interests',
              onPressed: showDeleteConfirmation,
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

    if (interests.isEmpty) {
      return const Center(child: Text('No interests submitted yet.'));
    }

    return RefreshIndicator(
      onRefresh: loadInterests,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: interests.length,
        itemBuilder: (context, index) {
          final interest = interests[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    interest.listingTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text('Category: ${interest.category}'),

                  const SizedBox(height: 4),

                  Text('Area Code: ${interest.areaCode}'),

                  const SizedBox(height: 4),

                  Text('Price: ₹${interest.price.toStringAsFixed(0)}'),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(interest.status),
                    ],
                  ),

                  if (interest.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Text('Submitted: ${formatDate(interest.createdAt!)}'),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> deleteAllInterests() async {
    try {
      await apiService.deleteAllInterests();

      if (!mounted) return;

      setState(() {
        interests.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All interests deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete interests: $e')));
    }
  }
}
