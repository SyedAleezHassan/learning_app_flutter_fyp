// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/home_page_icons/free_course_tap.dart';

// import '../screens/course_screen.dart';

class freeCourse extends StatefulWidget {
  final List<Map> imagList;
  freeCourse({required this.imagList});

  @override
  State<freeCourse> createState() => _freeCourseState();
}

class _freeCourseState extends State<freeCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Free Courses",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        backgroundColor: appColor.primaryColor,
      ),

      body: GridView.builder(
        itemCount: widget.imagList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              (MediaQuery.of(context).size.height - 50 - 25) / (4 * 240),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => freeOntap(
                            widget.imagList[index]['name'],
                            widget.imagList[index]["imgLink"],
                            widget.imagList[index]["video"],
                          )
                      //CourseScreen(
                      //   widget.imagList[index]["name"],
                      //   widget.imagList[index]["price"],
                      //   widget.imagList[index]["imgLink"],
                      //   widget.imagList[index]["video"],
                      // ),
                      ));
            },
            child: Container(
              margin: EdgeInsets.all(9),
              padding: EdgeInsets.symmetric(vertical: 19, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: appColor.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(20),
                color: Color((0xffF9F0F9)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      // "assets/images/${imgList[index]}.png",
                      widget.imagList[index]["imgLink"],
                      width: 100,
                      height: 90,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.imagList[index]["name"],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "55 videos",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Icon(
      //           Icons.sentiment_dissatisfied,
      //           color: appColor.primaryColor,
      //           size: 100.0,
      //         ),
      //         SizedBox(height: 20.0),
      //         Text(
      //           "Oops! No free course yet :(",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             fontSize: 24.0,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black54,
      //           ),
      //         ),
      //         SizedBox(height: 10.0),
      //         Text(
      //           "Stay tuned! We are working on adding new courses.",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             fontSize: 16.0,
      //             color: Colors.black45,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
