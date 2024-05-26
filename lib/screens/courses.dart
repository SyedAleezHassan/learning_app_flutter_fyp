import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/color/color.dart';

import 'course_screen.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

final TextEditingController _searchController = TextEditingController();

// List imagList = [
//   'Flutter',
//   'Python',
//   'C#',
//   'java',
// ];

List<Map> imagList = [
  {
    "imgLink": "assets/images/Flutter.png",
    "name": "Flutter",
    "video": "55 videos",
    "price": "50\$"
  },
  {
    "imgLink": "assets/images/java.png",
    "name": "java",
    "video": "55 videos",
    "price": "50\$"
  },
  {
    "imgLink": "assets/images/Python.png",
    "name": "Python",
    "video": "55 videos",
    "price": "50\$"
  },
];

class _CoursesState extends State<Courses> {
  List<Map> _filteredItems = [];
  @override
  void initState() {
    super.initState();
    _filteredItems = imagList;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = imagList;
      } else {
        _filteredItems = imagList
            .where((item) =>
                item["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterItems,
            ),
            GridView.builder(
              itemCount: _filteredItems.length,
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
                          builder: (context) =>
                              CourseScreen(imagList[index]["name"]),
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF5F3FF),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            // "assets/images/${_filteredItems[index]}.png",
                            _filteredItems[index]["imgLink"],
                            width: 100,
                            height: 90,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _filteredItems[index]["name"],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _filteredItems[index]["video"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          "Buy ${_filteredItems[index]["price"]}",
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
            ),
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
          ],
        ),
      ),
    );
  }
}
