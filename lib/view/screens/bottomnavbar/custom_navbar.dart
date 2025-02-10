import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/screens/college_list_screen/college_list_screen.dart';
import 'package:edupot/view/screens/dashboard/dashboard_screen.dart';
import 'package:edupot/view/screens/enquiry_form/enquiry_form.dart';
import 'package:edupot/view/screens/profile/screen_profile.dart';
import 'package:edupot/view/screens/students_list/screen_students.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }
}

class CustomBottomNavigation extends GetView<NavigationController> {
  final navigationController = Get.put(NavigationController());
  final List<Widget> pages = [
    DashboardScreen(),
    ScreenStudents(),
    const SizedBox(),
    const CollegeListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigationController.currentIndex.value != 0) {
          navigationController.setIndex(0);
          return false;
        }
        return true;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => IndexedStack(
                index: navigationController.currentIndex.value,
                children: pages,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: secondary,
                unselectedItemColor: const Color(0xFF868889),
                currentIndex: navigationController.currentIndex.value,
                onTap: (index) {
                  if (index != 2) {
                    navigationController.setIndex(index);
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'Students',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add, color: Colors.transparent),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_outlined),
                    label: 'Colleges',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  backgroundColor: primaryButton,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                  elevation: 2,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => EnquiryForm()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
