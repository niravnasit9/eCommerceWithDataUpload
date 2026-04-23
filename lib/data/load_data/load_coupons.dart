import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/abstract/coupons.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/coupons/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class LoadCouponsScreen extends StatelessWidget {
  const LoadCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final couponRepo = Get.find<CouponRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Coupons'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Default Coupons',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'This will add the following default coupons to your Firebase database:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// List of default coupons
            Expanded(
              child: ListView.builder(
                itemCount: defaultCoupons.length,
                itemBuilder: (_, index) {
                  final coupon = defaultCoupons[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: ListTile(
                      leading: const Icon(Iconsax.discount_circle, color: TColors.primary),
                      title: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(coupon.description),
                      trailing: Text(coupon.discountText, style: const TextStyle(fontWeight: FontWeight.bold, color: TColors.primary)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    TLoaders.customDialog(message: 'Uploading coupons...');
                    
                    for (var coupon in defaultCoupons) {
                      // Check if coupon already exists
                      final existing = await couponRepo.getCouponByCode(coupon.code);
                      if (existing == null) {
                        await couponRepo.addCoupon(coupon);
                        print('✅ Added coupon: ${coupon.code}');
                      } else {
                        print('⏭️ Coupon already exists: ${coupon.code}');
                      }
                    }
                    
                    TLoaders.hideDialog();
                    TLoaders.successSnackBar(
                      title: 'Success!',
                      message: 'Default coupons uploaded successfully',
                    );
                    
                    // Optional: Navigate back after 2 seconds
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                  } catch (e) {
                    TLoaders.hideDialog();
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to upload coupons: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.arrow_up),
                label: const Text('Upload Default Coupons'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Check Existing Coupons Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final coupons = await couponRepo.getAllCoupons();
                    TLoaders.successSnackBar(
                      title: 'Info',
                      message: 'Found ${coupons.length} coupons in database',
                    );
                  } catch (e) {
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to fetch coupons: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.search_status),
                label: const Text('Check Existing Coupons'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}