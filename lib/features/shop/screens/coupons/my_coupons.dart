import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/coupons/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final couponRepo = Get.find<CouponRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coupons'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: FutureBuilder<List<CouponModel>>(
        future: couponRepo.getValidCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.discount_circle,
                    size: 64,
                    color: dark ? TColors.grey : TColors.darkGrey,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Error loading coupons',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final coupons = snapshot.data ?? [];

          if (coupons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.discount_circle,
                    size: 64,
                    color: dark ? TColors.grey : TColors.darkGrey,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'No coupons available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    'Check back later for exciting offers!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: coupons.length,
            itemBuilder: (_, index) {
              final coupon = coupons[index];
              return _buildCouponCard(context, coupon, dark);
            },
          );
        },
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context, CouponModel coupon, bool dark) {
    final isExpired = coupon.isExpired;
    final isValid = coupon.isValid && !isExpired;

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: isValid ? TColors.primary : TColors.error,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isValid ? TColors.primary : TColors.error,
                  isValid ? TColors.primary.withOpacity(0.7) : TColors.error.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TSizes.borderRadiusMd),
                topRight: Radius.circular(TSizes.borderRadiusMd),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.code,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coupon.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                // Copy Button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon.code));
                    TLoaders.successSnackBar(
                      title: 'Copied!',
                      message: '${coupon.code} copied to clipboard',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    ),
                    child: const Row(
                      children: [
                        Icon(Iconsax.copy, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Discount Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: isValid 
                        ? TColors.primary.withOpacity(0.1)
                        : TColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.discount_circle,
                        size: 20,
                        color: isValid ? TColors.primary : TColors.error,
                      ),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        coupon.discountText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isValid ? TColors.primary : TColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Minimum Order Requirement
                if (coupon.minimumOrderAmount != null && coupon.minimumOrderAmount! > 0)
                  Row(
                    children: [
                      const Icon(Iconsax.money, size: 14, color: TColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        'Minimum Order: ₹${coupon.minimumOrderAmount!.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: TColors.warning,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: TSizes.xs),

                /// Validity
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: 14,
                      color: isValid ? TColors.secondary : TColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Valid till: ${_formatDate(coupon.validTo)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isValid ? TColors.secondary : TColors.error,
                      ),
                    ),
                  ],
                ),

                if (!isValid && !coupon.isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: TSizes.sm),
                    child: Container(
                      padding: const EdgeInsets.all(TSizes.sm),
                      decoration: BoxDecoration(
                        color: TColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.warning_2, size: 14, color: TColors.error),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              coupon.isExpired 
                                  ? 'This coupon has expired'
                                  : 'This coupon is currently inactive',
                              style: TextStyle(
                                fontSize: 11,
                                color: TColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Divider
          Divider(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
            height: 1,
          ),

          /// Footer - Apply Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (coupon.minimumOrderAmount != null && coupon.minimumOrderAmount! > 0)
                  Text(
                    'Min. Order: ₹${coupon.minimumOrderAmount!.toInt()}',
                    style: TextStyle(
                      fontSize: 11,
                      color: dark ? TColors.grey : TColors.darkGrey,
                    ),
                  ),
                // ElevatedButton.icon(
                //   onPressed: isValid
                //       ? () {
                //           // Navigate to products screen with the coupon
                //           Clipboard.setData(ClipboardData(text: coupon.code));
                //           TLoaders.successSnackBar(
                //             title: 'Coupon Code Copied!',
                //             message: 'Use ${coupon.code} at checkout',
                //           );
                //           Get.back();
                //         }
                //       : null,
                //   icon: const Icon(Iconsax.copy, size: 16),
                //   label: const Text('Copy Code'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: isValid ? TColors.primary : TColors.grey,
                //     padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}