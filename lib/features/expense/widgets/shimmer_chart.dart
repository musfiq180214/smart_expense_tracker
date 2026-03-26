import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerChart extends StatelessWidget {
  const ShimmerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 150,
        color: Colors.white,
      ),
    );
  }
}
