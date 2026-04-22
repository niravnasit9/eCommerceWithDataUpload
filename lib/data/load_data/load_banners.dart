import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class LoadBannersScreen extends StatelessWidget {
  const LoadBannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerRepo = Get.find<BannerRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Banners'),
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
              'Upload Default Banners',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'This will add the following default banners to your Firebase database:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(Iconsax.image, 'Total Banners', bannerRepo.bannerAssets.length.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// List of default banners
            Expanded(
              child: ListView.builder(
                itemCount: bannerRepo.bannerAssets.length,
                itemBuilder: (_, index) {
                  final assetPath = bannerRepo.bannerAssets[index];
                  final fileName = assetPath.split('/').last;
                  return Card(
                    margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: ListTile(
                      leading: const Icon(Iconsax.image, color: TColors.primary),
                      title: Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(assetPath),
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
                    TLoaders.customDialog(message: 'Uploading banners...');
                    
                    await bannerRepo.uploadBannersForceClean();
                    
                    TLoaders.hideDialog();
                    TLoaders.successSnackBar(
                      title: 'Success!',
                      message: '${bannerRepo.bannerAssets.length} banners uploaded successfully',
                    );
                    
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                  } catch (e) {
                    TLoaders.hideDialog();
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to upload banners: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.arrow_up),
                label: const Text('Upload Default Banners'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Check Existing Banners Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final banners = await bannerRepo.fetchBanners();
                    TLoaders.successSnackBar(
                      title: 'Info',
                      message: 'Found ${banners.length} active banners in database',
                    );
                  } catch (e) {
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to fetch banners: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.search_status),
                label: const Text('Check Existing Banners'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: TColors.primary),
        const SizedBox(height: TSizes.xs),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}