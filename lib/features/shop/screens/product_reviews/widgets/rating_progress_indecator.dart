import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_reviews/widgets/progress_indecator_and_rating.dart';

class TOverallProductRating extends StatelessWidget {
  const TOverallProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '4.8',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        const Expanded(
          flex: 7,
          child: Column(
            children: [
              TRatingProgressIndecator(text: '5', value: 1.0,),
              TRatingProgressIndecator(text: '4', value: 0.8,),
              TRatingProgressIndecator(text: '3', value: 0.6,),
              TRatingProgressIndecator(text: '2', value: 0.4,),
              TRatingProgressIndecator(text: '1', value: 0.2,),
            ],
          ),
        ),
      ],
    );
  }
}
