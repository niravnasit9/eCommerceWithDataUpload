import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/products/ratings/rating_indecator.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                  backgroundImage: AssetImage(TImages.userProfileImage2)),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text('Nirav Nasit',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      const SizedBox(height: TSizes.spaceBtwItems),

      ///   Reviews
      const Row(
        children: [
          TRatingBarIndecator(rating: 4),
          SizedBox(width: TSizes.spaceBtwItems),
          Text('28/08/2024'),
        ],
      ),
      const SizedBox(height: TSizes.spaceBtwItems),
      const ReadMoreText(
        'The userinterface of the app is Quite intuitive.I Was anle to Navigate and Make Purchase Seamlessy=ly,Great Job',
        trimExpandedText: 'Show Less',
        moreStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        lessStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        trimCollapsedText: 'Show More',
        trimLength: 1,
        trimMode: TrimMode.Line,
      ),

      ///   Company Reviews
      TRoundedContainer(
        backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nirav Nasit',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('25 Nov,2023',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const ReadMoreText(
                'The userinterface of the app is Quite intuitive.I Was anle to Navigate and Make Purchase Seamlessy=ly,Great Job',
                trimExpandedText: 'Show Less',
                moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary),
                lessStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary),
                trimCollapsedText: 'Show More',
                trimLength: 1,
                trimMode: TrimMode.Line,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: TSizes.spaceBtwSections),
    ]);
  }
}
