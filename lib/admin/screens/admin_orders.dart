import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_order_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_order_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_filter_chip.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/order/order_details.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminOrders extends StatelessWidget {
  const AdminOrders({super.key});

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);
    final controller = Get.put(AdminOrderController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Search Bar
                    AdminSearchBar(
                      hintText: 'Search orders by ID or User ID...',
                      onChanged: controller.searchOrders,
                      onSubmitted: (value) {
                        controller.searchOrders(value);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Stats Row 1
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'Total Orders',
                            value: controller.totalOrders.value.toString(),
                            icon: Iconsax.shopping_cart,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Pending',
                            value: controller.pendingOrders.value.toString(),
                            icon: Iconsax.clock,
                            color: TColors.warning,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Processing',
                            value: controller.processingOrders.value.toString(),
                            icon: Iconsax.repeat,
                            color: TColors.info,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Confirmed',
                            value: controller.confirmedOrders.value.toString(),
                            icon: Iconsax.tick_circle,
                            color: TColors.success,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Stats Row 2
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'Shipped',
                            value: controller.shippedOrders.value.toString(),
                            icon: Iconsax.ship,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Out for Delivery',
                            value: controller.outForDeliveryOrders.value.toString(),
                            icon: Iconsax.truck,
                            color: TColors.secondary,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Delivered',
                            value: controller.deliveredOrders.value.toString(),
                            icon: Iconsax.tick_circle,
                            color: TColors.success,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Cancelled',
                            value: controller.cancelledOrders.value.toString(),
                            icon: Iconsax.close_circle,
                            color: TColors.error,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Stats Row 3
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'Refunded',
                            value: controller.refundedOrders.value.toString(),
                            icon: Iconsax.money_recive,
                            color: TColors.warning,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(child: Container()),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(child: Container()),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(child: Container()),
                      ],
                    )),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Status Filter Chips
                    SizedBox(
                      height: 50,
                      child: Obx(() => ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          AdminFilterChip(
                            label: 'All',
                            isSelected: controller.selectedStatus.value == 'All',
                            onPressed: () => controller.filterByStatus('All'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Pending',
                            isSelected: controller.selectedStatus.value == 'Pending',
                            onPressed: () => controller.filterByStatus('Pending'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Processing',
                            isSelected: controller.selectedStatus.value == 'Processing',
                            onPressed: () => controller.filterByStatus('Processing'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Confirmed',
                            isSelected: controller.selectedStatus.value == 'Confirmed',
                            onPressed: () => controller.filterByStatus('Confirmed'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Shipped',
                            isSelected: controller.selectedStatus.value == 'Shipped',
                            onPressed: () => controller.filterByStatus('Shipped'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Out for Delivery',
                            isSelected: controller.selectedStatus.value == 'Out for Delivery',
                            onPressed: () => controller.filterByStatus('Out for Delivery'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Delivered',
                            isSelected: controller.selectedStatus.value == 'Delivered',
                            onPressed: () => controller.filterByStatus('Delivered'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Cancelled',
                            isSelected: controller.selectedStatus.value == 'Cancelled',
                            onPressed: () => controller.filterByStatus('Cancelled'),
                          ),
                          const SizedBox(width: TSizes.sm),
                          AdminFilterChip(
                            label: 'Refunded',
                            isSelected: controller.selectedStatus.value == 'Refunded',
                            onPressed: () => controller.filterByStatus('Refunded'),
                          ),
                        ],
                      )),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Orders List
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.filteredOrders.isEmpty) {
                          return AdminEmptyState(
                            icon: Iconsax.shopping_cart,
                            title: 'No orders found',
                            subtitle: controller.selectedStatus.value == 'All'
                                ? 'No orders have been placed yet'
                                : 'No ${controller.selectedStatus.value.toLowerCase()} orders found',
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.filteredOrders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                          itemBuilder: (_, index) {
                            final order = controller.filteredOrders[index];
                            return AdminOrderCard(
                              order: order,
                              onUpdateStatus: (orderId, status) {
                                controller.updateOrderStatus(orderId, status);
                              },
                              onViewDetails: () {
                                Get.to(() => OrderDetailsScreen(order: order));
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}