import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'navBar_controller.dart';

class GoogleNavBar extends StatelessWidget {
  const GoogleNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavBarController controller = Get.put(BottomNavBarController());
    return Scaffold(
        bottomNavigationBar: GNav(
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: appColor.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          iconSize: 29,
          gap: 4,
          duration: const Duration(milliseconds: 900),
          onTabChange: (value) {
            controller.index.value = value;
          },
          tabs: const [
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.assignment, text: "Courses"),
            GButton(icon: Icons.favorite, text: "Wishlist"),
            // GButton(icon: Icons.logout, text: "Favroite"),
            GButton(icon: Icons.person_2_outlined, text: "Account"),
          ],
        ),
        body: Obx(() => controller.page[controller.index.value]));
  }
}
