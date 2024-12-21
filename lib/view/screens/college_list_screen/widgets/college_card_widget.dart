import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/college_list_screen/college_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/college_list_screen/college_details_screen.dart';
import 'package:flutter/material.dart';
class CollegeCard extends StatelessWidget {
  final String name;
  final String university;
  final String address;
  final String about;
  final String logo;
  final String logoPath;
  final List<String> images;
  final String brochurePath;

  const CollegeCard({
    super.key,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    required this.logo,
    required this.logoPath,
    required this.images,
    required this.brochurePath,
  });

  @override
  Widget build(BuildContext context) {
    final String fullLogoUrl = '$logoPath$logo';
    final List<String> fullImageUrls = images.map((img) => '$brochurePath$img').toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollegeDetailsScreen(
              name: name,
              university: university,
              address: address,
              about: about,
              logo: fullLogoUrl,
              images: fullImageUrls,
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
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(fullLogoUrl),
              radius: 25,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyles.headingCollege),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    university,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
