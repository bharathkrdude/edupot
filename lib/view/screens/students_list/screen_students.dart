import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/student_details/student_details.dart';
import 'package:edupot/view/screens/students_list/widgets/student_listtile.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ScreenStudents extends StatelessWidget {
  const ScreenStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Students'),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          StudentListTile(
            name: 'Aleena',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://tse2.mm.bing.net/th?id=OIP.n5CeR93916slWXGyV13PuAHaHa&pid=Api&P=0&h=180', onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: Student(
       id: '3',
        name: 'pocco',
        email: 'example@example.com',
        phone: '9544500637',
        parentName: 'bparent',
        parentPhone: '1211321312312',
        stream: 'aaaaa',
        status: 'Hot',
        stage: 'Closed',
        remark: 'aaaaaaaaa',
        priority: 22,
        photoUrl: 'https://via.placeholder.com/150'
      ),)));  },
          ),
          kHeight5,
          StudentListTile(
            name: 'Rony Philip',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://www.profilebakery.com/wp-content/uploads/2023/04/Profile-Image-AI.jpg', onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: Student(
        id: '3',
        name: 'pocco',
        email: 'example@example.com',
        phone: '9544500637',
        parentName: 'bparent',
        parentPhone: '1211321312312',
        stream: 'aaaaa',
        status: 'Hot',
        stage: 'Closed',
        remark: 'aaaaaaaaa',
        priority: 22,
        photoUrl: 'https://via.placeholder.com/150'
      ),))); },
          ),
          kHeight5,
          StudentListTile(
            name: 'Alwin jhonny',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://publichealth.uga.edu/wp-content/uploads/2020/01/Thomas-Cameron_Student_Profile.jpg', onPressed: () {  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: Student(
        id: '3',
        name: 'pocco',
        email: 'example@example.com',
        phone: '9544500637',
        parentName: 'bparent',
        parentPhone: '1211321312312',
        stream: 'aaaaa',
        status: 'Hot',
        stage: 'Closed',
        remark: 'aaaaaaaaa',
        priority: 22,
        photoUrl: 'https://via.placeholder.com/150'
      ),)));},
          ),
          kHeight5,
          StudentListTile(
            name: 'Amanda Jose',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://offertabs.s3.amazonaws.com/offer/qy9s4z/large/810_1920_608edddd38a10-DSC-01451.JPG', onPressed: () {  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: Student(
       id: '3',
        name: 'pocco',
        email: 'example@example.com',
        phone: '9544500637',
        parentName: 'bparent',
        parentPhone: '1211321312312',
        stream: 'aaaaa',
        status: 'Hot',
        stage: 'Closed',
        remark: 'aaaaaaaaa',
        priority: 22,
        photoUrl: 'https://via.placeholder.com/150'
      ),)));},
          ),
          kHeight5,
          StudentListTile(
            name: 'Christo',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://tse1.mm.bing.net/th?id=OIP.50zUU5a9Pg64KnQ1ScmlJQHaE8&pid=Api&P=0&h=180', onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: Student(
      id: '3',
        name: 'pocco',
        email: 'example@example.com',
        phone: '9544500637',
        parentName: 'bparent',
        parentPhone: '1211321312312',
        stream: 'aaaaa',
        status: 'Hot',
        stage: 'Closed',
        remark: 'aaaaaaaaa',
        priority: 22,
        photoUrl: 'https://via.placeholder.com/150'
      ),))); },
          ),
          kHeight5,
          StudentListTile(
            
            name: 'Ashly benny',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://thumbs.dreamstime.com/z/portrait-female-student-standing-college-building-portrait-female-student-standing-college-building-104866088.jpg', onPressed: () {  },
          ),kHeight5,
          StudentListTile(
            name: 'Aleena',
            grade: 'Grade 10 - Science',
            phone: '+1 234 567 8900',
            imageUrl:
                'https://thumbs.dreamstime.com/z/portrait-female-student-standing-college-building-portrait-female-student-standing-college-building-104866088.jpg', onPressed: () {  },
          ),
          kHeight50
        ],
      ),
    );
  }
}
