import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageProductWidget extends StatelessWidget {
  const ImageProductWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const SizedBox(
        height: 120,
        child: Center(child: Icon(Icons.broken_image)),
      ),
    );
  }
}
