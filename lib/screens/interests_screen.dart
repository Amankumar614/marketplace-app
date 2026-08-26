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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Interests')),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 50),
              const SizedBox(height: 12),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadInterests,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (interests.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadInterests,
        child: ListView(
          children: const [
            SizedBox(height: 250),
            Center(child: Text('No interests submitted yet.')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadInterests,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: interests.length,
        itemBuilder: (context, index) {
          final interest = interests[index];

          return buildInterestCard(interest);
        },
      ),
    );
  }

  Widget buildInterestCard(Interest interest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROPERTY NAME
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.home_work_outlined, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    interest.propertyName.isNotEmpty
                        ? interest.propertyName
                        : 'Property',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // STATUS
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(interest.status),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            const Divider(),

            // USER NAME
            Text('Name: ${interest.fullName}'),

            const SizedBox(height: 6),

            // MOBILE
            Text('Mobile: ${interest.mobile}'),

            const SizedBox(height: 6),

            // EMAIL
            Text('Email: ${interest.email}'),

            const SizedBox(height: 12),

            // MESSAGE
            if (interest.message.isNotEmpty) ...[
              const Text(
                'Message:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(interest.message),
            ],
          ],
        ),
      ),
    );
  }
}
