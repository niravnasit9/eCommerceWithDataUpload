import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_coupon_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_coupon_form.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_coupon_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class AdminCoupons extends StatelessWidget {
  const AdminCoupons({super.key});

  @override
  Widget build(BuildContext context) {
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
            /// Search Bar
            AdminSearchBar(
              hintText: 'Search coupons by code or description...',
              onChanged: controller.searchCoupons,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats Row 1 - Basic Stats
            Obx(() => Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Coupons',
                    value: controller.totalCoupons.value.toString(),
                    icon: Iconsax.discount_circle,
                    color: TColors.primary,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'Active',
                    value: controller.activeCoupons.value.toString(),
                    icon: Iconsax.tick_circle,
                    color: TColors.success,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'Expired',
                    value: controller.expiredCoupons.value.toString(),
                    icon: Iconsax.close_circle,
                    color: TColors.error,
                  ),
                ),
              ],
            )),

            /// Stats Row 2 - Usage Stats
            Obx(() => Padding(
              padding: const EdgeInsets.only(top: TSizes.spaceBtwItems),
              child: Row(
                children: [
                  Expanded(
                    child: AdminStatCard(
                      title: 'Total Uses',
                      value: controller.totalUses.value.toString(),
                      icon: Iconsax.receipt,
                      color: TColors.info,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: AdminStatCard(
                      title: 'Unique Users',
                      value: controller.uniqueUsers.value.toString(),
                      icon: Iconsax.profile_2user,
                      color: TColors.success,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: AdminStatCard(
                      title: 'Avg Uses/Coupon',
                      value: controller.averageUsesPerCoupon.value.toStringAsFixed(1),
                      icon: Iconsax.chart,
                      color: TColors.warning,
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Coupons List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredCoupons.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.discount_circle,
                    title: 'No coupons found',
                    subtitle: controller.searchQuery.value.isNotEmpty
                        ? 'No coupons match your search'
                        : 'Click the + button to add your first coupon',
                    onActionPressed: () => Get.to(() => const AddCouponForm()),
                    actionText: 'Add Coupon',
                  );
                }
                return ListView.separated(
                  itemCount: controller.filteredCoupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final coupon = controller.filteredCoupons[index];
                    return AdminCouponCard(
                      coupon: coupon,
                      onEdit: () => Get.to(() => AddCouponForm(coupon: coupon)),
                      onDelete: () => AdminDeleteConfirmation.show(
                        context: context,
                        title: 'Delete Coupon',
                        message: 'Are you sure you want to delete "${coupon.code}"? This action cannot be undone.',
                        onConfirm: () => controller.deleteCoupon(coupon.id),
                      ),
                      onToggleStatus: () => controller.toggleCouponStatus(coupon.id, !coupon.isActive),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}