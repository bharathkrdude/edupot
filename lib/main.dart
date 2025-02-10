import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/core/services/authprovier.dart';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/viewmodels/college_viewmodel.dart';
import 'package:edupot/viewmodels/dash_board_viewmodel.dart';
import 'package:edupot/viewmodels/forgot_password_viewmodel.dart';
import 'package:edupot/viewmodels/staff_profile_provider.dart';
import 'package:edupot/viewmodels/students_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:edupot/view/screens/splash/screen_splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => CollegeViewModel()),
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(
          create: (context) =>
              LeadProvider(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider<StudentViewModel>(
          create: (context) => StudentViewModel(
            context.read<LeadProvider>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => StaffProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
