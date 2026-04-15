import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_product_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_product_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_product_form.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class AdminProducts extends StatelessWidget {
  const AdminProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminProductController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddProductForm()),
        backgroundColor: TColors.primary,
        icon: const Icon(Iconsax.add),
        label: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Search Bar
            AdminSearchBar(
              hintText: 'Search products...',
              onChanged: controller.searchProducts,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats Row - With loading state
            Obx(() {
              if (controller.isLoading.value) {
                return Row(
                  children: [
                    Expanded(child: _buildShimmerCard()),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(child: _buildShimmerCard()),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(child: _buildShimmerCard()),
                  ],
                );
              }
              
              return Row(
                children: [
                  Expanded(
                    child: AdminStatCard(
                      title: 'Total Products',
                      value: controller.totalProducts.value.toString(),
                      icon: Iconsax.shop,
                      color: TColors.primary,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: AdminStatCard(
                      title: 'Active',
                      value: controller.activeProducts.value.toString(),
                      icon: Iconsax.tick_circle,
                      color: TColors.success,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: AdminStatCard(
                      title: 'Out of Stock',
                      value: controller.outOfStockProducts.value.toString(),
                      icon: Iconsax.close_circle,
                      color: TColors.error,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Products List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.shop,
                    title: 'No products found',
                    subtitle: 'Click the + button to add your first product',
                    onActionPressed: () => Get.to(() => const AddProductForm()),
                    actionText: 'Add Product',
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final product = controller.filteredProducts[index];
                    return AdminProductCard(
                      product: product,
                      onEdit: () => Get.to(() => AddProductForm(product: product)),
                      onDelete: () => AdminDeleteConfirmation.show(
                        context: context,
                        title: 'Delete Product',
                        message: 'Are you sure you want to delete this product?',
                        onConfirm: () => controller.deleteProduct(product.id),
                      ),
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

  Widget _buildShimmerCard() {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(height: TSizes.xs),
          Container(
            width: 50,
            height: 20,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(height: TSizes.xs),
          Container(
            width: 70,
            height: 15,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}