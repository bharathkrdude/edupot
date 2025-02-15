import 'package:edupot/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppSizes {
  // This function returns the screen width based on the context
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

const kHeight10 = SizedBox(height: 10);
const kHeight5 = SizedBox(height: 5);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);

const kHeight15 = SizedBox(height: 15);

const kHeight30 = SizedBox(height: 30);
const kHeight35 = SizedBox(height: 35);
const kHeight40 = SizedBox(height: 40);
const kHeight50 = SizedBox(height: 50);
const kWidth5 = SizedBox(width: 5);
const kWidth25 = SizedBox(width: 25);
const kWidth10 = SizedBox(width: 10);
const kWidth15 = SizedBox(width: 15);
const kWidth20 = SizedBox(width: 20);
const kWidth30 = SizedBox(width: 30);
const kWidth40 = SizedBox(width: 40);
const kWidth50 = SizedBox(width: 50);

// Textstyles
class TextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static TextStyle SubtitleCollege = TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        )
                      ;
  static const TextStyle headingCollege = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle bodyTextWhite = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle bodyTextWhitesmall = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static const TextStyle hintTextStyle1 = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static const TextStyle hintTextStyle2 = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );
  static const TextStyle drawerText = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    color: primaryButton,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black, 
  );
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Image.asset(
          'assets/images/Logo Edupot-01.png',
        ));
  }
}
