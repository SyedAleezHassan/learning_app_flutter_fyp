import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

class liveCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Live Courses",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        backgroundColor: appColor.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.deepPurple,
                size: 100.0,
              ),
              SizedBox(height: 20.0),
              Text(
                "Oops! No live classes yet :(",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Stay tuned! We are coming live for you soon.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
