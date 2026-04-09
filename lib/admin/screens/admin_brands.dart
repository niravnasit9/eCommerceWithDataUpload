import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_brand_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_brand_form.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminBrands extends StatelessWidget {
  const AdminBrands({super.key});

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);
    final controller = Get.put(AdminBrandController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddBrandForm()),
        backgroundColor: TColors.primary,
        icon: const Icon(Iconsax.add),
        label: const Text('Add Brand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Search Bar
            AdminSearchBar(
              hintText: 'Search brands...',
              onChanged: controller.searchBrands,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats
            Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Brands',
                    value: controller.totalBrands.value.toString(),
                    icon: Iconsax.tag,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'Featured',
                    value: controller.featuredBrandsCount.value.toString(),
                    icon: Iconsax.star,
                    color: TColors.warning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Brands Grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredBrands.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.tag,
                    title: 'No brands found',
                    subtitle: 'Click the + button to add your first brand',
                    onActionPressed: () => Get.to(() => const AddBrandForm()),
                    actionText: 'Add Brand',
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: TSizes.spaceBtwItems,
                    crossAxisSpacing: TSizes.spaceBtwItems,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.filteredBrands.length,
                  itemBuilder: (_, index) {
                    final brand = controller.filteredBrands[index];
                    return AdminBrandCard(
                      brand: brand,
                      onEdit: () => Get.to(() => AddBrandForm(brand: brand)),
                      onDelete: () => AdminDeleteConfirmation.show(
                        context: context,
                        title: 'Delete Brand',
                        message: 'Are you sure you want to delete this brand? This action cannot be undone.',
                        onConfirm: () => controller.deleteBrand(brand.id),
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
}