import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';

class TBannerShimmer extends StatelessWidget {
  const TBannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: TShimmerEffect(width: double.infinity, height: 200), // Customize shimmer effect
    );
  }
}
