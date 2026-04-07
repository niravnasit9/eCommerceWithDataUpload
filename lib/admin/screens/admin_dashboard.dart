import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_banner_form.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_product_form.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_brand_form.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(AdminController());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Section
          Text(
            'Welcome back, Admin!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            'Here\'s what\'s happening with your store today.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? TColors.grey : TColors.darkGrey,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Stats Grid
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: TSizes.spaceBtwItems,
              crossAxisSpacing: TSizes.spaceBtwItems,
              childAspectRatio: 1.2,
              children: [
                AdminStatsCard(
                  title: 'Total Products',
                  value: controller.totalProducts.value.toString(),
                  icon: Iconsax.shop,
                  color: TColors.primary,
                  change: controller.productGrowth.value,
                ),
                AdminStatsCard(
                  title: 'Total Orders',
                  value: controller.totalOrders.value.toString(),
                  icon: Iconsax.shopping_cart,
                  color: TColors.success,
                  change: controller.orderGrowth.value,
                ),
                AdminStatsCard(
                  title: 'Total Users',
                  value: controller.totalUsers.value.toString(),
                  icon: Iconsax.user,
                  color: TColors.info,
                  change: controller.userGrowth.value,
                ),
                AdminStatsCard(
                  title: 'Total Revenue',
                  value: '₹${controller.totalRevenue.value.toStringAsFixed(0)}',
                  icon: Iconsax.money,
                  color: TColors.warning,
                  change: controller.revenueGrowth.value,
                ),
              ],
            );
          }),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Recent Orders Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to orders screen
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Recent Orders List
          Container(
            decoration: BoxDecoration(
              color: dark ? TColors.dark : TColors.white,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
              border: Border.all(
                color: dark ? TColors.borderSecondary : TColors.borderPrimary,
              ),
            ),
            child: Obx(() {
              if (controller.isLoadingOrders.value) {
                return const Padding(
                  padding: EdgeInsets.all(TSizes.md),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.recentOrders.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Center(
                    child: Text(
                      'No recent orders',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.recentOrders.length > 5
                    ? 5
                    : controller.recentOrders.length,
                separatorBuilder: (_, __) => Divider(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
                itemBuilder: (_, index) {
                  final order = controller.recentOrders[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: TColors.primary.withOpacity(0.1),
                      child: const Icon(Iconsax.shopping_cart, size: 20),
                    ),
                    title: Text('Order #${order.id.substring(0, 8)}'),
                    subtitle: Text('₹${order.totalAmount.toStringAsFixed(0)}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                      ),
                      child: Text(
                        order.orderStatusText,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(order.status),
                            ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          /// Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Iconsax.add_square,
                  title: 'Add Product',
                  onTap: () {
                    Get.to(() => const AddProductForm());
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Iconsax.tag,
                  title: 'Add Brand',
                  onTap: () {
                    Get.to(() => const AddBrandForm());
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: Iconsax.image,
                  title: 'Add Banner',
                  onTap: () {
                    Get.to(() => const AddBannerForm());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final dark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          border: Border.all(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: TColors.primary),
            const SizedBox(height: TSizes.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TColors.warning;
      case OrderStatus.confirmed:
        return TColors.info;
      case OrderStatus.shipped:
        return TColors.primary;
      case OrderStatus.outForDelivery:
        return TColors.secondary;
      case OrderStatus.delivered:
        return TColors.success;
      case OrderStatus.cancelled:
        return TColors.error;
      default:
        return TColors.primary;
    }
  }
}