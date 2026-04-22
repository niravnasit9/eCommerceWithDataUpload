import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class TCouponCode extends StatelessWidget {
  const TCouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final checkoutController = Get.find<CheckoutController>();
    final cartTotal = Get.find<CartController>().totalCartPrice.value;

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Applied Coupon Display
        if (checkoutController.appliedCoupon.value != null)
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: TColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              border: Border.all(color: TColors.success),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Iconsax.discount_circle, color: TColors.success),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coupon Applied: ${checkoutController.appliedCoupon.value!.code}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              checkoutController.appliedCoupon.value!.discountText,
                              style: TextStyle(fontSize: 12, color: TColors.success),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => checkoutController.removeCoupon(),
                  child: const Text('Remove', style: TextStyle(color: TColors.error)),
                ),
              ],
            ),
          ),

        if (checkoutController.appliedCoupon.value == null) ...[
          /// Coupon Input Field
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: dark ? TColors.borderSecondary : TColors.borderPrimary),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: checkoutController.couponController,
                    onChanged: (value) {
                      checkoutController.searchCoupons(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Coupon Code',
                      prefixIcon: Icon(Iconsax.discount_circle),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(TSizes.md),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(TSizes.xs),
                  child: ElevatedButton(
                    onPressed: () {
                      if (checkoutController.couponController.text.isNotEmpty) {
                        checkoutController.applyCoupon(
                          checkoutController.couponController.text.trim()
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.md,
                        vertical: TSizes.sm,
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),

          /// Search Suggestions Dropdown
          if (checkoutController.searchResults.isNotEmpty && checkoutController.couponController.text.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: TSizes.xs),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkoutController.searchResults.length > 5 
                    ? 5 
                    : checkoutController.searchResults.length,
                separatorBuilder: (_, __) => Divider(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                  height: 1,
                ),
                itemBuilder: (_, index) {
                  final coupon = checkoutController.searchResults[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Iconsax.discount_circle, color: TColors.primary, size: 20),
                    title: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(coupon.discountText, style: const TextStyle(fontSize: 12)),
                    trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                    onTap: () {
                      checkoutController.couponController.text = coupon.code;
                      checkoutController.searchResults.clear();
                      checkoutController.applyCoupon(coupon.code);
                    },
                  );
                },
              ),
            ),

          const SizedBox(height: TSizes.spaceBtwItems),

          /// Available Offers Section - Horizontal Scroll
          if (checkoutController.availableCoupons.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Offers',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${checkoutController.availableCoupons.length} offers',
                      style: TextStyle(fontSize: 12, color: TColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  height: 145,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: checkoutController.availableCoupons.length,
                    separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                    itemBuilder: (_, index) {
                      final coupon = checkoutController.availableCoupons[index];
                      return _buildCouponCard(context, coupon, checkoutController, cartTotal);
                    },
                  ),
                ),
              ],
            ),
          
          /// No Offers Message
          if (checkoutController.availableCoupons.isEmpty && checkoutController.isLoadingCoupons == false)
            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.darkerGrey : TColors.softGrey,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle, color: dark ? TColors.grey : TColors.darkGrey),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Text(
                      cartTotal > 0 
                          ? 'No coupons available for your cart total. Add more items to qualify for offers.'
                          : 'Add items to your cart to see available coupons and offers.',
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? TColors.grey : TColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    ));
  }

  Widget _buildCouponCard(
    BuildContext context,
    CouponModel coupon,
    CheckoutController controller,
    double cartTotal,
  ) {
    final dark = THelperFunctions.isDarkMode(context);
    final isApplicable = coupon.minimumOrderAmount == null || cartTotal >= coupon.minimumOrderAmount!;
    
    return Container(
      width: 210,
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: isApplicable 
            ? (dark ? TColors.dark : TColors.white)
            : (dark ? TColors.darkerGrey : TColors.softGrey),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: isApplicable ? TColors.primary : Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Coupon Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  coupon.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                coupon.discountText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          
          /// Description
          Text(
            coupon.description,
            style: TextStyle(
              fontSize: 10,
              color: dark ? TColors.grey : TColors.darkGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          /// Minimum Order
          if (coupon.minimumOrderAmount != null && coupon.minimumOrderAmount! > 0)
            Row(
              children: [
                Icon(Iconsax.money, size: 10, color: isApplicable ? TColors.success : TColors.error),
                const SizedBox(width: 2),
                Text(
                  'Min: ₹${coupon.minimumOrderAmount!.toInt()}',
                  style: TextStyle(
                    fontSize: 9,
                    color: isApplicable ? TColors.success : TColors.error,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          
          /// Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isApplicable 
                  ? () => controller.applySuggestedCoupon(coupon)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                ),
                minimumSize: const Size(0, 28),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}