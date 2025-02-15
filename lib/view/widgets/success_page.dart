import 'package:edupot/view/screens/bottomnavbar/custom_navbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  void _playAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _isAnimationComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40), 
                Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_uu0x8lqv.json',
                  height: 200,
                  repeat: false,
                  onLoaded: (composition) {
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green[700],
                    );
                  },
                ),

                AnimatedOpacity(
                  opacity: _isAnimationComplete ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Text(
                        'Success!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your submission has been received',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                AnimatedOpacity(
                  opacity: _isAnimationComplete ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: "back to home",
                        onPressed: () {
                          
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => CustomBottomNavigation(),
                          ));
                        },
                      )),
                ),
                const SizedBox(height: 20), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
