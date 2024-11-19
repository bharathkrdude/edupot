import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 30,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return InkWell(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: color,
          ),
        );
      }),
    );
  }
}
