import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

class categoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Programming Languages',
      'description':
          'Learn popular programming languages like Python, Java, and C++.',
      'icon': Icons.code,
      'color': Colors.blueAccent,
    },
    {
      'title': 'Graphics Designing',
      'description':
          'Master the art of graphics designing with tools like Photoshop and Illustrator.',
      'icon': Icons.design_services,
      'color': Colors.greenAccent,
    },
    {
      'title': 'Databases Learning',
      'description':
          'Understand the fundamentals of databases like SQL, MongoDB, and more.',
      'icon': Icons.storage,
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Hosting',
      'description':
          'Get to know about web hosting, cloud services, and domain management.',
      'icon': Icons.cloud,
      'color': Colors.orangeAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learning Categories",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        backgroundColor: appColor.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: category['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Container(
                  width:
                      double.infinity, // Makes the card fill the screen width
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        category['icon'],
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        category['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        category['description'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
