import 'package:edupot/core/constants/colors.dart';
import 'package:flutter/material.dart';

class InfoContainerWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const InfoContainerWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.3, // Increased width
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12, // Smaller font size
                fontWeight: FontWeight.normal, // Less bold
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // Larger font size
                fontWeight: FontWeight.bold, // Bold for emphasis
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SubjectExperienceSection extends StatelessWidget {
  final List<SubjectExperienceItem> subjects;

  const SubjectExperienceSection({
    Key? key,
    required this.subjects, required Null Function(dynamic subject, dynamic isSelected) onSubjectSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
      
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subject Exp.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pay Per Class',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: subjects.map((subject) {
              return SubjectExperienceRow(subject: subject);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SubjectExperienceRow extends StatelessWidget {
  final SubjectExperienceItem subject;

  const SubjectExperienceRow({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_box_outline_blank_outlined,
            size: 14,
            color: Colors.black87,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              subject.name,
              style: TextStyle(
                fontSize: 14,
                color: hintTextColor,
              ),
            ),
          ),
          Text(
            '\$${subject.price}',
            style: TextStyle(
              fontSize: 14,
              color: hintTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectExperienceItem {
  final String name;
  final double price;
  final bool isSelected;
  final Color? iconColor;

  SubjectExperienceItem({
    required this.name,
    required this.price,
    this.isSelected = false,
    this.iconColor,
  });
}
