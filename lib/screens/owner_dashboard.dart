import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/property.dart';
import '../models/interest.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class OwnerDashboard extends StatefulWidget {
  final User user;

  const OwnerDashboard({super.key, required this.user});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final apiService = ApiService();

  List<Property> properties = [];
  List<Interest> interests = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        apiService.getOwnerProperties(widget.user.id),
        apiService.getOwnerInterests(widget.user.id),
      ]);

      if (!mounted) return;

      setState(() {
        properties = results[0] as List<Property>;

        interests = results[1] as List<Interest>;

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userRole');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: loadData,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Welcome, ${widget.user.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'My Properties (${properties.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...properties.map(
                      (property) => Card(
                        child: ListTile(
                          title: Text(property.name),
                          subtitle: Text(
                            '${property.type} • '
                            '${property.location}\n'
                            '₹${property.price.toStringAsFixed(0)} • '
                            '${property.area.toStringAsFixed(0)} sq.ft',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Interest Submissions (${interests.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (interests.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('No interest submissions yet.'),
                        ),
                      ),

                    ...interests.map(
                      (interest) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                interest.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(interest.propertyName),

                              Text(interest.mobile),

                              Text(interest.email),

                              const SizedBox(height: 8),

                              Text(interest.message),

                              const SizedBox(height: 8),

                              Chip(label: Text(interest.status)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
