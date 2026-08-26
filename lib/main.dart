import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/listing_screen.dart';
import 'screens/owner_dashboard.dart';
import 'models/user.dart';

void main() {
  runApp(const PropertyApp());
}

class PropertyApp extends StatefulWidget {
  const PropertyApp({super.key});

  @override
  State<PropertyApp> createState() => _PropertyAppState();
}

class _PropertyAppState extends State<PropertyApp> {
  late Future<Widget> _homePageFuture;

  @override
  void initState() {
    super.initState();
    _homePageFuture = _getHomePage();
  }

  Future<Widget> _getHomePage() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final userRole = prefs.getString('userRole') ?? 'User';
      final dummyUser = User(
        id: '1',
        name: 'User',
        email: 'user@test.com',
        role: userRole,
      );

      if (userRole == 'User') {
        return ListingScreen(user: dummyUser);
      } else {
        return OwnerDashboard(user: dummyUser);
      }
    }
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property Marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _homePageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
    );
  }
}
