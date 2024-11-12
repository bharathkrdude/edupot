import 'package:flutter/material.dart';

class TutorTileWidget extends StatelessWidget {
  final String imageUrl;
  final String tutorName;
  final String subjects;
  final double imageSize;

  const TutorTileWidget({
    super.key,
    required this.imageUrl,
    required this.tutorName,
    required this.subjects,
    this.imageSize = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tutorName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subjects,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
