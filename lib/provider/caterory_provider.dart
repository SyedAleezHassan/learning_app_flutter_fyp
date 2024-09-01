import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  List<Map<String, dynamic>> courseList = [];

  List<Map<String, dynamic>> gdList = [];
  List<Map<String, dynamic>> plList = [];
  void filterCourses(List<Map<String, dynamic>> courseList) {
    // Lists to store filtered data

    // Iterate over the data list
    for (var course in courseList) {
      // Check if id is 'GD' and add to gdList
      if (course['id'] == 'GD') {
        gdList.add(course);
      }
      // Check if id is 'PL' and add to plList
      else if (course['id'] == 'PL') {
        plList.add(course);
      }
    }
    print("Graphics Design (GD) Courses: $gdList");
    print("Programming Languages (PL) Courses: $plList");
  }

//////////////////////filter

  // Function to retrieve all data from 'courses' collection
  Future<void> getCoursesData() async {
    try {
      // Get all documents from 'courses' collection
      QuerySnapshot querySnapshot = await courses.get();

      // Clear the list to avoid duplication
      courseList.clear();

      // Iterate through the documents and store data in courseList
      querySnapshot.docs.forEach((doc) {
        courseList.add(doc.data() as Map<String, dynamic>);
      });
      filterCourses(courseList);

      // Refresh the UI after fetching the data
      // setState(() {});
      print(courseList);
    } catch (e) {
      print("Error getting courses: $e");
    }
  }
}
