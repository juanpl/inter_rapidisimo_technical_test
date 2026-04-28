import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageProductWidget extends StatelessWidget {
  const ImageProductWidget({
    super.key,
    required this.imageUrl,
    this.height = 120,
    this.width = double.infinity,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => SizedBox(
        height: height,
        width: width,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: const Center(child: Icon(Icons.broken_image)),
      ),
    );
  }
}
