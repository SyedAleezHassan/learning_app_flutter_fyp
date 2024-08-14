import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/screens/course_screen.dart';
import 'package:flutter_application_1/screens/courses.dart';
import 'package:flutter_application_1/screens/home_screen.dart';

import '../screens/account.dart';
import '../screens/my_courses.dart';

class GoogleNavBar extends StatefulWidget {
  const GoogleNavBar({super.key});

  @override
  State<GoogleNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int currentIndex = 0;
  List screens = [
    HomePage(),
    const Courses(),
    MyCourses(),
    Myaccount(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       currentIndex = 2;
      //     });
      //   },
      //   shape: const CircleBorder(),
      //   backgroundColor: const Color.fromARGB(255, 255, 156, 7),
      //   child: const Icon(
      //     Icons.home,
      //     size: 30,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: Colors.white,
        // shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              icon: Icon(
                Icons.home,
                size: 30,
                color: currentIndex == 0 ? appColor.primaryColor : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              icon: Icon(
                Icons.assessment,
                size: 30,
                color: currentIndex == 1 ? appColor.primaryColor : Colors.grey,
              ),
            ),
            // const SizedBox(
            //   width: 15,
            // ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              icon: Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: currentIndex == 2 ? appColor.primaryColor : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              icon: Icon(
                Icons.person_2_outlined,
                size: 30,
                color: currentIndex == 3 ? appColor.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:get/get.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'navBar_controller.dart';

// class GoogleNavBar extends StatefulWidget {
//   const GoogleNavBar({super.key});

//   @override
//   State<GoogleNavBar> createState() => _GoogleNavBarState();
// }

// class _GoogleNavBarState extends State<GoogleNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     BottomNavBarController controller = Get.put(BottomNavBarController());
//     setState(() {});
//     return Scaffold(
//         bottomNavigationBar: GNav(
//           backgroundColor: Colors.white,
//           color: Colors.grey,
//           activeColor: appColor.primaryColor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
//           iconSize: 29,
//           gap: 4,
//           duration: const Duration(milliseconds: 900),
//           onTabChange: (value) {
//             controller.index.value = value;
//           },
//           tabs: const [
//             GButton(icon: Icons.home, text: "Home"),
//             GButton(icon: Icons.assignment, text: "Courses"),
//             GButton(icon: Icons.favorite, text: "My Courses"),
//             // GButton(icon: Icons.logout, text: "Favroite"),
//             GButton(icon: Icons.person_2_outlined, text: "Account"),
//           ],
//         ),
//         body: Obx(() => controller.page[controller.index.value]));
//   }
// }
