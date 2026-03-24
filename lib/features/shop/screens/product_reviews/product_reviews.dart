import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/products/ratings/rating_indecator.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_reviews/widgets/rating_progress_indecator.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Ratings and Reviews are verified and are from people who use same type of devices that you use."),
              SizedBox(height: TSizes.spaceBtwItems),

              /// Overall Product Rating
              TOverallProductRating(),

              TRatingBarIndecator(rating: 3.5),

              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

