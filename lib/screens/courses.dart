// import 'package:flutter/cupertino.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_screen.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => CoursesState();
}

final TextEditingController _searchController = TextEditingController();

class CoursesState extends State<Courses> {
  // String capitalize(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _formatSearchQuery(String query) {
    if (query.isEmpty) return query;
    return query[0].toUpperCase() + query.substring(1).toLowerCase();
  }

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _formatSearchQuery(_searchController.text.trim());
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Future fetchItems() async {
  //   // Simulating network delay
  //   await Future.delayed(Duration(seconds: 2));

  //   // Return your data here
  //   return _filteredItems; // Replace _filteredItems with the actual data fetching logic
  // }
//bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
//   addcourses() {
//     // Call the user's CollectionReference to add a new user
// //  CollectionReference courses =
//     FirebaseFirestore.instance
//         .collection('courses')
//         .add({
//          "imgLink": "assets/images/React Native.png",
//     "name": "React Native",
//     "video": "55 videos",
//     "price": "50\$"
//         })
//         .then((value) => print("User Added"))
//         .catchError((error) => print("Failed to add user: $error"));
//     // return courses
//   }
//bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
  @override
  Widget build(BuildContext context) {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('courses');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        title: Text(
          "Courses",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 13, right: 13, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 9),
                width: MediaQuery.of(context).size.width,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: appColor.primaryColor, width: 1)),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text) {
                    setState(() {
                      _searchQuery = _formatSearchQuery(text.trim());
                    });
                  },
                  // _filterItems,
                ),
              ),

              //naya kaam with  searchMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
              StreamBuilder(
                stream: (_searchQuery.isEmpty)
                    ? courses.snapshots()
                    : courses
                        .where('name', isGreaterThanOrEqualTo: _searchQuery)
                        .where('name',
                            isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items found'));
                  } else {
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.height - 50 - 25) /
                                (4 * 240),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot abc = snapshot.data!.docs[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseScreen(abc["name"],
                                    abc["price"], abc["imgLink"], abc['video']),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: appColor.primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffF9F0F9),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Image.network(
                                      abc["imgLink"],
                                      width: 100,
                                      height: 80,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // Return the child widget when loading is complete
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null, // Show the progress based on bytes loaded
                                            ),
                                          );
                                        }
                                      },
                                    )),
                                SizedBox(height: 10),
                                Text(
                                  abc["name"],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  abc["video"],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Text(
                                  "Buy ${abc["price"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//2222222222222666666666667777777777777777777


   // if (snapshot.hasError) {
                //   return Text("Something went wrong");
                // }


                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // } else if (snapshot.hasError) {
                //   return Center(child: Text('Error: ${snapshot.error}'));
                // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   return Center(child: Text('No items found'));
                // } else {
                //   final items = snapshot.data!;

            // GridView.builder(
            //   itemCount: _filteredItems.length,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     childAspectRatio:
            //         (MediaQuery.of(context).size.height - 50 - 25) / (4 * 240),
            //     mainAxisSpacing: 10,
            //     crossAxisSpacing: 10,
            //   ),
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //       onTap: () {
            //         // addcourses();

            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => CourseScreen(
            //                   imagList[index]["name"],
            //                   imagList[index]["price"]),
            //             ));
            //       },
            //       child: Container(
            //         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           color: Color(0xFFF5F3FF),
            //         ),
            //         child: Column(
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.all(10),
            //               child: Image.asset(
            //                 // "assets/images/${_filteredItems[index]}.png",
            //                 _filteredItems[index]["imgLink"],
            //                 width: 100,
            //                 height: 90,
            //               ),
            //             ),
            //             SizedBox(height: 10),
            //             Text(
            //               _filteredItems[index]["name"],
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.black.withOpacity(0.6),
            //               ),
            //             ),
            //             SizedBox(height: 10),
            //             Text(
            //               _filteredItems[index]["video"],
            //               style: TextStyle(
            //                 fontSize: 15,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black.withOpacity(0.5),
            //               ),
            //             ),
            //             Text(
            //               "Buy ${_filteredItems[index]["price"]}",
            //               style: TextStyle(
            //                 fontSize: 15,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.green[600],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: _filteredItems.length,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           color: Color(0xFFF5F3FF),
            //         ),
            //         child: Column(
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.all(10),
            //               child: Image.asset(
            //                 "assets/images/${_filteredItems[index]}.png",
            //                 width: 100,
            //                 height: 90,
            //               ),
            //             ),
            //             SizedBox(height: 10),
            //             Text(
            //               imagList[index],
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.black.withOpacity(0.6),
            //               ),
            //             ),
            //             SizedBox(height: 10),
            //             Text(
            //               "55 videos",
            //               style: TextStyle(
            //                 fontSize: 15,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black.withOpacity(0.5),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
