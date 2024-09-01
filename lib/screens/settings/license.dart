import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

class LicensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licenses'),
        foregroundColor: appColor.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: appColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'License Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLicenseItem(
                      'Flutter',
                      '© 2017-2024 The Flutter Authors. All rights reserved.',
                      'https://flutter.dev',
                    ),
                    _buildLicenseItem(
                      'Firebase',
                      '© 2013-2024 The Firebase Authors. All rights reserved.',
                      'https://firebase.google.com',
                    ),
                    _buildLicenseItem(
                      'Dart',
                      '© 2011-2024 The Dart Authors. All rights reserved.',
                      'https://dart.dev',
                    ),
                    // Add more licenses as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseItem(String title, String description, String link) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Implement link tap action (e.g., open browser)
            },
            child: Text(
              link,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Divider(height: 32, thickness: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
