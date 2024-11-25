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
    const SizedBox(), // Empty widget for center button
    const CollegeListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Page View based on currentIndex
        Positioned.fill(
          child: Obx(
            () => IndexedStack(
              index: navigationController.currentIndex.value,
              children: pages,
            ),
          ),
        ),

        // Bottom Navigation Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Obx(
            () => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: secondary,
              unselectedItemColor: Color(0xFF868889),
              currentIndex: navigationController.currentIndex.value,
              onTap: (index) {
                // Skip center index (2) as it's for FAB
                if (index != 2) {
                  navigationController.setIndex(index);
                }
              },
              items: [
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

        // Floating Action Button
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
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
                elevation: 2,
                onPressed: () {
                  // Handle FAB click
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => EnquiryForm()));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}




// Bottom sheet for FAB click
class AddOptionsSheet extends GetView<NavigationController> {
  const AddOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Create Post'),
            onTap: () {
              Get.back();
              // Navigate to create post page
              Get.to(() => CreatePostPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Upload Media'),
            onTap: () {
              Get.back();
              // Navigate to media upload page
              Get.to(() => UploadMediaPage());
            },
          ),
        ],
      ),
    );
  }
}

// Example pages for navigation
class CreatePostPage extends GetView<NavigationController> {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Center(child: Text('Create Post Page')),
    );
  }
}

class UploadMediaPage extends GetView<NavigationController> {
  const UploadMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Media')),
      body: Center(child: Text('Upload Media Page')),
    );
  }
}
