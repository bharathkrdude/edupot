import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/screens/college_list_screen/college_details_screen.dart';
import 'package:flutter/material.dart';

class CollegeCard extends StatelessWidget {
  final String collegeName;
  final String location;
  final String coursesOffered;
  final String examsAccepted;
  final String placementRating;
  final String imageUrl;

  const CollegeCard({
    Key? key,
    required this.collegeName,
    required this.location,
    required this.coursesOffered,
    required this.examsAccepted,
    required this.placementRating,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollegeDetailsScreen(
              collegeName: collegeName,
              location: location,
              coursesOffered: coursesOffered,
              examsAccepted: examsAccepted,
              placementRating: placementRating,
              imageUrl: imageUrl,
              brochureImages: [
                // Pass some example brochure images
                'https://tse3.mm.bing.net/th?id=OIP.pkeiMEyzcxq0SIji4YR56gHaE8&pid=Api&P=0&h=180',
                'https://lh5.googleusercontent.com/W3SkZszsQQkNJ7koq1qx_9EFU0Fq7LvLao-Z09xIoctb-Fppbmohl6h90oXbuQ5Y5H95289X2QF3r2OiDQhFHygAdjn1aSgSK3El3yx4BZ7jLXAZuEqe9sL4O9MF3bEec6tztINdWctpITwM4Xzn6s3idggpi_i2s77rHrDUzjf583hIV0WHOHHBwqkakw',
                'https://www.creativefabrica.com/wp-content/uploads/2021/11/02/Education-Trifold-Brochure-Template-Graphics-19561648-1.jpg',
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Avatar and Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 25,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collegeName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Courses Offered and Exams Accepted
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn('Courses Offered', coursesOffered),
                _detailColumn('Exams Accepted', examsAccepted),
              ],
            ),
            const SizedBox(height: 16),

            // Placement Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn(
                  'Placement Rating',
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        placementRating,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Brochure Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the details page via Brochure button as well
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollegeDetailsScreen(
                        collegeName: collegeName,
                        location: location,
                        coursesOffered: coursesOffered,
                        examsAccepted: examsAccepted,
                        placementRating: placementRating,
                        imageUrl: imageUrl,
                        brochureImages: [
                          'https://via.placeholder.com/300.png',
                          'https://via.placeholder.com/400.png',
                          'https://via.placeholder.com/500.png',
                        ],
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.download, size: 18, color: white),
                label: Text(
                  'Download Brochure',
                  style: TextStyle(color: white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButton,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail columns
  Widget _detailColumn(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        value is Widget
            ? value
            : Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}
