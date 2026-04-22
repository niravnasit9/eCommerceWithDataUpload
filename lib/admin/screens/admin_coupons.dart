import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_coupon_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_coupon_form.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminCoupons extends StatelessWidget {
  const AdminCoupons({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(AdminCouponController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddCouponForm()),
        backgroundColor: TColors.primary,
        icon: const Icon(Iconsax.add),
        label: const Text('Add Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            AdminSearchBar(
              hintText: 'Search coupons...',
              onChanged: controller.searchCoupons,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            Obx(() => Row(
              children: [
                Expanded(child: AdminStatCard(
                  title: 'Total Coupons',
                  value: controller.totalCoupons.value.toString(),
                  icon: Iconsax.discount_circle,
                  color: TColors.primary,
                )),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(child: AdminStatCard(
                  title: 'Active',
                  value: controller.activeCoupons.value.toString(),
                  icon: Iconsax.tick_circle,
                  color: TColors.success,
                )),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(child: AdminStatCard(
                  title: 'Expired',
                  value: controller.expiredCoupons.value.toString(),
                  icon: Iconsax.close_circle,
                  color: TColors.error,
                )),
              ],
            )),

            const SizedBox(height: TSizes.spaceBtwSections),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredCoupons.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.discount_circle,
                    title: 'No coupons found',
                    subtitle: 'Click the + button to add your first coupon',
                    onActionPressed: () => Get.to(() => const AddCouponForm()),
                    actionText: 'Add Coupon',
                  );
                }
                return ListView.separated(
                  itemCount: controller.filteredCoupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final coupon = controller.filteredCoupons[index];
                    return _buildCouponCard(context, coupon, dark, controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context, CouponModel coupon, bool dark, AdminCouponController controller) {
    final isExpired = coupon.isExpired;
    final isActive = coupon.isActive && !isExpired;

    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(color: isActive ? TColors.primary : TColors.error, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TColors.primary, width: 0.5),
                ),
                child: Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? TColors.success.withOpacity(0.1) : TColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(isActive ? 'Active' : (isExpired ? 'Expired' : 'Inactive'),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? TColors.success : TColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(coupon.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Icon(Iconsax.discount_circle, size: 16, color: TColors.primary),
              const SizedBox(width: 4),
              Text(coupon.discountText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 16),
              if (coupon.minimumOrderAmount != null)
                Row(
                  children: [
                    Icon(Iconsax.money, size: 14, color: TColors.warning),
                    const SizedBox(width: 4),
                    Text('Min: ₹${coupon.minimumOrderAmount!.toInt()}', style: TextStyle(fontSize: 12, color: TColors.warning)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            children: [
              Icon(Iconsax.receipt, size: 14, color: TColors.info),
              const SizedBox(width: 4),
              Text('Used: ${coupon.usedCount} / ${coupon.usageLimit == 0 ? '∞' : coupon.usageLimit}',
                style: TextStyle(fontSize: 12, color: TColors.info)),
              const SizedBox(width: 16),
              Icon(Iconsax.calendar, size: 14, color: TColors.secondary),
              const SizedBox(width: 4),
              Text('Valid till: ${coupon.validTo.day}/${coupon.validTo.month}/${coupon.validTo.year}',
                style: TextStyle(fontSize: 12, color: TColors.secondary)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => Get.to(() => AddCouponForm(coupon: coupon)),
                icon: const Icon(Iconsax.edit, size: 18),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => AdminDeleteConfirmation.show(
                  context: context,
                  title: 'Delete Coupon',
                  message: 'Are you sure you want to delete this coupon?',
                  onConfirm: () => controller.deleteCoupon(coupon.id),
                ),
                icon: const Icon(Iconsax.trash, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: TColors.error),
              ),
              const SizedBox(width: 8),
              Switch(value: coupon.isActive, onChanged: (value) => controller.toggleCouponStatus(coupon.id, value),
                activeColor: TColors.success),
            ],
          ),
        ],
      ),
    );
  }
}