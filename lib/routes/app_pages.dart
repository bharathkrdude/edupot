import 'package:edupot/view/screens/authentication/login.dart';
import 'package:edupot/view/screens/bottomnavbar/custom_navbar.dart';
import 'package:edupot/view/screens/enquiry_form/enquiry_form.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    // GetPage(
    //   name: AppRoutes.HOME,
    //   page: () => HomeView(),

    // ),
     GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => CustomBottomNavigation(),
      
    ),
    GetPage(
      name: AppRoutes.FORM,
      page: () => EnquiryForm(),
      
    ),
   
    // Add other pages here
  ];
}
