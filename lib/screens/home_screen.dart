//import 'dart:ffi';

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/home_page_icons/category.dart';
import 'package:flutter_application_1/home_page_icons/leaderBoard.dart';
import 'package:flutter_application_1/navBar/navBar.dart';
import 'package:flutter_application_1/provider/caterory_provider.dart';
import 'package:flutter_application_1/screens/Quizes/course_certification.dart';
import 'package:flutter_application_1/screens/course_screen.dart';
import 'package:flutter_application_1/screens/courses.dart';
import 'package:flutter_application_1/screens/my_courses.dart';
import 'package:provider/provider.dart';

import '../home_page_icons/books.dart';
import '../home_page_icons/classes.dart';
import '../home_page_icons/freeCourse.dart';
import '../home_page_icons/free_course_tap.dart';
import '../home_page_icons/liveCourse.dart';
// import 'package:flutter_application_1/screens/login.dart';
// import 'package:flutter_application_1/screens/welcome_screen.dart';
// import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false).getCoursesData();
    });
  }

  //creating static data in lists
  List catNames = [
    'Category',
    'All Courses',
    'Free Courses',
    'BookStore',
    'Demo Class',
    'Achievements',
  ];

  List<Color> catColors = [
    Color(0xFFFFCF2F),
    Color(0xFF6FE08D),
    Color(0xFF61BDFD),
    Color(0xFFFC7F7F),
    Color(0xFFCBB4FB),
    Color(0xFF78E667),
  ];

  List<Icon> catIcons = [
    Icon(Icons.category, color: Colors.white, size: 30),
    Icon(Icons.video_library, color: Colors.white, size: 30),
    Icon(Icons.assignment, color: Colors.white, size: 30),
    Icon(Icons.store, color: Colors.white, size: 30),
    Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
    Icon(Icons.emoji_events, color: Colors.white, size: 30),
  ];

  // List imgList = [
  //   'Flutter',
  //   'React Native',
  //   'Python',
  //   'C#',
  // ];
  // final List<Map> imagList;
  // freeCourse({required this.imagList});

  final List<Map> imagList = [
    {
      "imgLink": "assets/images/Flutter.png",
      "name": "Flutter",
      "video": "55 videos",
      "price": "50\$"
    },
    {
      "imgLink": "assets/images/java.png",
      "name": "Java",
      "video": "55 videos",
      "price": "50\$"
    },
    {
      "imgLink": "assets/images/Python.png",
      "name": "Python",
      "video": "55 videos",
      "price": "50\$"
    },
    {
      "imgLink": "assets/images/React Native.png",
      "name": "React Native",
      "video": "55 videos",
      "price": "50\$"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: appColor.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.dashboard,
                        size: 30,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 15),
                    child: Text(
                      "Hi, Programmer",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Search here...",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                GridView.builder(
                  itemCount: catNames.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: catColors[index],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: catIcons[index],
                            ),
                          ),
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => categoryPage()));
                            }
                            if (index == 1) {
                              final parentState = context
                                  .findAncestorStateOfType<GoogleNavBarState>();
                              if (parentState != null) {
                                parentState.updateIndex(1);
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (contex) => classes()));
                            }
                            if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => freeCourse(
                                            imagList: [
                                              {
                                                "imgLink":
                                                    "assets/images/Assembly.png",
                                                "name": "Assembly",
                                                "video": "55 videos",
                                                "price": "50\$"
                                              }
                                            ],
                                          )));
                            }
                            if (index == 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfListScreen()));
                            }
                            if (index == 4) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => liveCourse()));
                            }
                            if (index == 5) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CertificatePageSelector()));
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          catNames[index],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.7)),
                        )
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Courses",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: appColor.primaryColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Courses()));

                        // setState(() {
                        //   navigateToAnotherPage();
                        //   Navigator.pop(context, 1);
                        // });

                        // final parentState = context
                        //     .findAncestorStateOfType<GoogleNavBarState>();
                        // if (parentState != null) {
                        //   parentState.updateIndex(1);
                        // }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GridView.builder(
                  itemCount: imagList.length,
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
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseScreen(
                                imagList[index]["name"],
                                imagList[index]["price"],
                                imagList[index]["imgLink"],
                                imagList[index]["video"],
                              ),
                            ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                              child: Image.asset(
                                // "assets/images/${imgList[index]}.png",
                                imagList[index]["imgLink"],
                                width: 100,
                                height: 90,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              imagList[index]["name"],
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
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   // currentIndex: 0,
      //   showUnselectedLabels: true,
      //   iconSize: 32,
      //   selectedItemColor: Color(0xFF674AEF),
      //   selectedFontSize: 18,
      //   unselectedItemColor: Colors.grey,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.assignment), label: 'Courses'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.favorite), label: 'Wishlist'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      //   ],
      //   onTap: _handleNavigationChange,
      // ),
    );
  }

  // void _handleNavigationChange(int index) {
  //   setState(() {
  //     switch (index) {
  //       case 0:
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => HomePage()));
  //         // _child = HomePage();
  //         print("Index");
  //         break;
  //       case 1:
  //         // _child = WelcomeScreen();
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => WelcomeScreen()));

  //         print("Index 1");

  //         break;
  //       // case 2:
  //       //   _child = SearchResult();
  //       //   break;
  //       // case 3:
  //       //   _child = MessageScreen();
  //       //   break;
  //     }
  //     // _child = AnimatedSwitcher(
  //     //   switchInCurve: Curves.fastEaseInToSlowEaseOut, //easeout//easein
  //     //   switchOutCurve: Curves.linear,
  //     //   duration: Duration(milliseconds: 300),
  //     //   child: _child,
  //     // );
  //   });
  // }
}
