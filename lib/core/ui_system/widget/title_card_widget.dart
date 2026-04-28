import 'package:flutter/material.dart';

class TitleCardWidget extends StatelessWidget {
  const TitleCardWidget({super.key, required this.title, this.fontSize = 13});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
