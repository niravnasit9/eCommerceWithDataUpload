import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_banner_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_search_bar.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_banner_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_stats_card.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_empty_state.dart';
import 'package:yt_ecommerce_admin_panel/admin/widgets/admin_delete_confirmation.dart';
import 'package:yt_ecommerce_admin_panel/admin/forms/add_banner_form.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class AdminBanners extends StatelessWidget {
  const AdminBanners({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminBannerController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddBannerForm()),
        backgroundColor: TColors.primary,
        icon: const Icon(Iconsax.add),
        label: const Text('Add Banner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// Search Bar
            AdminSearchBar(
              hintText: 'Search banners...',
              onChanged: controller.searchBanners,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats
            Obx(() => Row(
              children: [
                Expanded(
                  child: AdminStatCard(
                    title: 'Total Banners',
                    value: controller.totalBanners.value.toString(),
                    icon: Iconsax.image,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: AdminStatCard(
                    title: 'Active',
                    value: controller.activeBanners.value.toString(),
                    icon: Iconsax.tick_circle,
                    color: TColors.success,
                  ),
                ),
              ],
            )),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Banners List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredBanners.isEmpty) {
                  return AdminEmptyState(
                    icon: Iconsax.image,
                    title: 'No banners found',
                    subtitle: 'Click the + button to add your first banner',
                    onActionPressed: () => Get.to(() => const AddBannerForm()),
                    actionText: 'Add Banner',
                  );
                }

                return ListView.separated(
                  itemCount: controller.filteredBanners.length,
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final banner = controller.filteredBanners[index];
                    return AdminBannerCard(
                      banner: banner,
                      onEdit: () => Get.to(() => AddBannerForm(banner: banner)),
                      onDelete: () => AdminDeleteConfirmation.show(
                        context: context,
                        title: 'Delete Banner',
                        message: 'Are you sure you want to delete this banner? This action cannot be undone.',
                        onConfirm: () => controller.deleteBanner(banner.id),
                      ),
                      onToggleStatus: () => controller.toggleBannerStatus(banner.id),
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