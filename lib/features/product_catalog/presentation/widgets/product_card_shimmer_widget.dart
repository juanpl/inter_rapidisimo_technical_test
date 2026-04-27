import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmerWidget extends StatelessWidget {
  const ProductCardShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 12, width: double.infinity, color: Colors.white),
              const SizedBox(height: 4),
              Container(height: 12, width: 120, color: Colors.white),
              const SizedBox(height: 8),
              Container(height: 12, width: 80, color: Colors.white),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(height: 12, width: 50, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(height: 12, width: 30, color: Colors.white),
                ],
              ),
              const SizedBox(height: 4),
              Container(height: 14, width: 60, color: Colors.white),
              const SizedBox(height: 6),
              Container(height: 12, width: 90, color: Colors.white),
              const Spacer(),
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
