import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/data/models/college_model.dart';
import 'package:edupot/view/screens/college_list_screen/college_details_screen.dart';
import 'package:flutter/material.dart';

class CollegeCard extends StatelessWidget {
  final String name;
  final String university;
  final String address;
  final String about;
  final String? logo;
  final String logoPath;
  final String location;
  final List<BrochureImage> brochurerelated;
  final List<FeesImage> feesrelated;
  final String brochureImagePath;
  final String feesImagePath;

  const CollegeCard({
    super.key,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    this.logo,
    required this.logoPath,
    required this.location,
    required this.brochurerelated,
    required this.feesrelated,
    required this.brochureImagePath,
    required this.feesImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final String? fullLogoUrl = logo != null ? '$logoPath$logo' : null;

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
              logo: logo,
            location: location,
              brochurerelated: brochurerelated,
              feesrelated: feesrelated,
              brochureImagePath: brochureImagePath,
              feesImagePath: feesImagePath,
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
              backgroundImage: fullLogoUrl != null 
                ? Image.network('$fullLogoUrl').image
                : null,
              radius: 25,
              child: fullLogoUrl == null 
                ? const Icon(Icons.school)
                : null,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          university,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: location == 'India' 
                            ? Colors.blue[100] 
                            : Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: location == 'India' 
                              ? Colors.blue[800] 
                              : Colors.green[800],
                          ),
                        ),
                      ),
                    ],
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
