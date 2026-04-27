import 'package:flutter/material.dart';

class TitleCardWidget extends StatelessWidget {
  final String title;

  const TitleCardWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
