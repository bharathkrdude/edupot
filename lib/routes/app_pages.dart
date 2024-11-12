import 'package:edupot/view/screens/authentication/login.dart';
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
      page: () => LoginScreen(),
      
    ),
    // Add other pages here
  ];
}
