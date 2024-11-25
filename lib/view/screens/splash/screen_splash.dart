import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edupot/view/screens/onboarding/screen_onboarding.dart';
import 'package:edupot/view/screens/bottomnavbar/custom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    // Check for token and navigate accordingly
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        print("Token found, navigating to CustomBottomNavigation");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigation(),
          ),
        );
      } else {
        print("No token found, navigating to OnboardingScreen");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Center(
          child: Image.asset(
            'assets/images/Logo Edupot-03.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
