import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/core/services/authprovier.dart';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/viewmodels/students_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:edupot/view/screens/splash/screen_splash.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        // AuthProvider handles user authentication logic
        ChangeNotifierProvider(create: (_) => AuthProvider()),
 
        // StudentViewModel is responsible for fetching students data
        // ChangeNotifierProvider(create: (_) => StudentViewModel()),
       

        // ApiService to handle API interactions
        Provider(create: (_) => ApiService()),

        // LeadProvider depends on ApiService
        ChangeNotifierProvider(
          create: (context) => LeadProvider(apiService: context.read<ApiService>()),
        ),
         ChangeNotifierProvider<StudentViewModel>(
          create: (context) => StudentViewModel(
            context.read<LeadProvider>(),
          ),
        ),
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
