import 'package:flutter/material.dart';

import '../models/property.dart';
import '../services/api_service.dart';

class ListingDetailScreen extends StatefulWidget {
  final Property property;

  const ListingDetailScreen({super.key, required this.property});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final ApiService apiService = ApiService();

  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  String? _validateFullName(String value) {
    if (value.isEmpty) return 'Full name is required';
    if (value.length < 2) return 'Full name must be at least 2 characters';
    if (value.length > 50) return 'Full name must not exceed 50 characters';
    return null;
  }

  String? _validateMobile(String value) {
    if (value.isEmpty) return 'Mobile number is required';
    final cleanedMobile = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedMobile.length != 10) return 'Mobile number must be 10 digits';
    if (!RegExp(r'^[6-9]').hasMatch(cleanedMobile)) {
      return 'Mobile number must start with 6-9';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validateMessage(String value) {
    if (value.isEmpty) return 'Message is required';
    if (value.length < 10) return 'Message must be at least 10 characters';
    if (value.length > 500) return 'Message must not exceed 500 characters';
    return null;
  }

  Future<void> submitInterest() async {
    final fullName = fullNameController.text.trim();
    final mobile = mobileController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    final fullNameError = _validateFullName(fullName);
    if (fullNameError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(fullNameError)));
      return;
    }

    final mobileError = _validateMobile(mobile);
    if (mobileError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mobileError)));
      return;
    }

    final emailError = _validateEmail(email);
    if (emailError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(emailError)));
      return;
    }

    final messageError = _validateMessage(message);
    if (messageError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(messageError)));
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await apiService.submitInterest(
        fullName: fullName,
        mobile: mobile,
        email: email,
        message: message,
        propertyId: widget.property.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interest submitted successfully. Status: Pending'),
        ),
      );

      Navigator.pop(context);
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
    final property = widget.property;

    return Scaffold(
      appBar: AppBar(title: const Text('Property Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE PLACEHOLDER
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.home_work_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PROPERTY NAME
            Text(
              property.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              property.location,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 20),

            _buildDetail('Type', property.type),

            _buildDetail('Price', '₹${property.price.toStringAsFixed(0)}'),

            _buildDetail('Area', '${property.area.toStringAsFixed(0)} sq.ft'),

            _buildDetail('Rooms', property.rooms.toString()),

            _buildDetail('Status', property.status),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              property.description.isEmpty
                  ? 'No description available.'
                  : property.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            const Text(
              'Owner',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              property.ownerName.isEmpty
                  ? 'Owner reference available'
                  : property.ownerName,
            ),

            const SizedBox(height: 32),

            const Text(
              'Submit Interest',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email ID',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // SELECTED PROPERTY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Selected Property: ${property.name}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitInterest,
                child:
                    isSubmitting
                        ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'Submit Interest',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
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
