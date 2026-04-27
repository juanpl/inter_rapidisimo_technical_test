import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarIndicatorCardWidget extends StatelessWidget {
  final double rating;

  const RatingBarIndicatorCardWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemCount: 5,
      itemSize: 16,
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
    );
  }
}
