import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/dashboard/widgets/info_container_widget.dart';
import 'package:edupot/view/screens/dashboard/widgets/tutor_tile_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final List<SubjectExperienceItem> subjectsList = [
    SubjectExperienceItem(
      name: 'Science',
      price: 100,
      isSelected: false,
    ),
    SubjectExperienceItem(
      name: 'Mathematics',
      price: 140,
      isSelected: true,
    ),
    SubjectExperienceItem(
      name: 'English',
      price: 130,
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorlightgrey,
      appBar: AppBar(
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
        title: Text(
          'Details of Tutor',
        ),
        backgroundColor: primaryButton,
        leading: Icon(
          Icons.arrow_back,
          color: white,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_list,
              color: white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_active_sharp,
              color: white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
              color: white,
              child: Column(
                children: [
                  kHeight30,
                  
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TutorTileWidget(
                      imageSize: 75,
                      imageUrl:
                          'https://play-lh.googleusercontent.com/7Ak4Ye7wNUtheIvSKnVgGL_OIZWjGPZNV6TP_3XLxHC-sDHLSE45aDg41dFNmL5COA',
                      tutorName: 'Zoe Martin',
                      subjects: 'science, Mathematics',
                    ),
                  ),
                  kHeight10
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  kHeight15,
                 
                  kHeight10,
                  SizedBox(
                    height: 80, // Set a fixed height for the ListView
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        InfoContainerWidget(
                          title: 'Year of Exp',
                          value: '10',
                          color: secondary,
                        ),
                        SizedBox(width: 8), // Spacing between items
                        InfoContainerWidget(
                          title: 'Teaches',
                          value: '1-5 std',
                          color: secondaryButton,
                        ),
                        SizedBox(width: 8), // Spacing between items
                        InfoContainerWidget(
                          title: 'University',
                          value: 'California',
                          color: secondary,
                        ),
                        SizedBox(width: 8), // Spacing between items
                        InfoContainerWidget(
                          title: 'Additional Info',
                          value: 'Some info',
                          color: secondaryButton,
                        ),
                        // Add more items here if needed
                      ],
                    ),
                  ),
                  kHeight25,
                  SubjectExperienceSection(
                    subjects: subjectsList,
                    onSubjectSelected: (subject, isSelected) {
                      print(
                          '${subject.name} is ${isSelected ? 'selected' : 'unselected'}');
                    },
                  ),
                  kHeight20,
                  SubjectExperienceSection(
                    subjects: subjectsList,
                    onSubjectSelected: (subject, isSelected) {
                      print(
                          '${subject.name} is ${isSelected ? 'selected' : 'unselected'}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
