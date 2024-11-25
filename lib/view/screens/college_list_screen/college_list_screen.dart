import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/college_list_screen/widgets/college_card_widget.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CollegeListScreen extends StatelessWidget {
  const CollegeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'colleges',),
       body: ListView(
        children: [
          CollegeCard(
            collegeName: "M.S. Ramaiah College of Law",
            location: "M.S. Ramaiah ",
            coursesOffered: "7 Courses ",
            examsAccepted: "CBSE 12th, Karnataka CET",
           
            placementRating: "3.7",
            imageUrl: "https://via.placeholder.com/150", // Replace with actual image URL
          ),
          CollegeCard(
            collegeName: "ISBR Law College",
            location: "Electronic City Phase 1",
            coursesOffered: "2 Courses",
            examsAccepted: "CLAT, LSAT",
         
            placementRating: "4.1",
            imageUrl: "https://via.placeholder.com/150", // Replace with actual image URL
          ),
          CollegeCard(
            collegeName: "Vidyashilp University",
            location: "Yelahanka",
            coursesOffered: "2 Courses",
            examsAccepted: "CBSE, Karnataka CET",
           
            placementRating: "4.5",
            imageUrl: "https://via.placeholder.com/150", // Replace with actual image URL
          ),
          kHeight50
        ],

      ),
    );
  }
}