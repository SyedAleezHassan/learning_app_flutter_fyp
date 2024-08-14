import "package:flutter_application_1/screens/courses.dart";
import "package:flutter_application_1/screens/home_screen.dart";
import "package:flutter_application_1/screens/account.dart";
import "package:get/get.dart";

import "../screens/my_courses.dart";

// import "../screens/course_screen.dart";

class BottomNavBarController {
  RxInt index = 0.obs;
  var page = [HomePage(), Courses(), MyCourses(), Myaccount()];
}
