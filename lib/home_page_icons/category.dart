import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/provider/caterory_provider.dart';
import 'package:flutter_application_1/screens/courses.dart';
import 'package:provider/provider.dart';

import '../navBar/navBar.dart';
import 'programming_screen.dart';

final GlobalKey<GoogleNavBarState> navBarKey = GlobalKey<GoogleNavBarState>();

class categoryPage extends StatefulWidget {
  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
//   CollectionReference courses =
//       FirebaseFirestore.instance.collection('courses');

//   List<Map<String, dynamic>> courseList = [];

//   List<Map<String, dynamic>> gdList = [];
//   List<Map<String, dynamic>> plList = [];
//   void filterCourses(List<Map<String, dynamic>> courseList) {
//     // Lists to store filtered data

//     // Iterate over the data list
//     for (var course in courseList) {
//       // Check if id is 'GD' and add to gdList
//       if (course['id'] == 'GD') {
//         gdList.add(course);
//       }
//       // Check if id is 'PL' and add to plList
//       else if (course['id'] == 'PL') {
//         plList.add(course);
//       }
//     }
//     print("Graphics Design (GD) Courses: $gdList");
//     print("Programming Languages (PL) Courses: $plList");
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCoursesData();
//     // Timer(Duration(seconds: 1), () {
//     //   filterCourses(courseList);
//     // });
//   }
// //////////////////////filter

//   // Function to retrieve all data from 'courses' collection
//   Future<void> getCoursesData() async {
//     try {
//       // Get all documents from 'courses' collection
//       QuerySnapshot querySnapshot = await courses.get();

//       // Clear the list to avoid duplication
//       courseList.clear();

//       // Iterate through the documents and store data in courseList
//       querySnapshot.docs.forEach((doc) {
//         courseList.add(doc.data() as Map<String, dynamic>);
//       });

//       // Refresh the UI after fetching the data
//       // setState(() {});
//       print(courseList);
//     } catch (e) {
//       print("Error getting courses: $e");
//     }
//   }

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Programming Languages',
      'description':
          'Learn popular programming languages like Python, Java, and C++.',
      'icon': Icons.code,
      'color': Color.fromARGB(255, 30, 83, 177),
    },
    {
      'title': 'Graphics Designing',
      'description':
          'Master the art of graphics designing with tools like Photoshop and Illustrator.',
      'icon': Icons.design_services,
      'color': Color.fromARGB(255, 32, 117, 76),
    },
    {
      'title': 'Databases Learning',
      'description':
          'Understand the fundamentals of databases like SQL, MongoDB, and more.',
      'icon': Icons.storage,
      'color': Color.fromARGB(255, 120, 37, 134),
    },
    {
      'title': 'Hosting',
      'description':
          'Get to know about web hosting, cloud services, and domain management.',
      'icon': Icons.cloud,
      'color': const Color.fromARGB(255, 132, 89, 32),
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
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    print('@@@@@@@@@@@@@@@@@@@@koi mil gya');
                    // Provider.of<NavBarProvider>(context, listen: false).updateIndex(1);

                    // final parentState =
                    //     context.findAncestorStateOfType<GoogleNavBarState>();
                    // if (parentState != null) {
                    //   parentState.updateIndex(1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgrammingScreen(
                                
                                )));
                    // }
                  }
                },
                child: Card(
                  color: category['color'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Container(
                    width: double.infinity, // Mwidth
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
