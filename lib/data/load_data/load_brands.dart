import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/abstract/brands.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/brnads/brand_repository.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class LoadBrandsScreen extends StatelessWidget {
  const LoadBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandRepo = Get.find<BrandRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Brands'),
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
              'Upload Default Brands',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'This will add the following default brands to your Firebase database:',
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
                    _buildStatItem(Iconsax.tag, 'Total Brands', dummyBrands.length.toString()),
                    _buildStatItem(Iconsax.star, 'Featured', dummyBrands.where((b) => b.isFeatured == true).length.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// List of default brands
            Expanded(
              child: ListView.builder(
                itemCount: dummyBrands.length,
                itemBuilder: (_, index) {
                  final brand = dummyBrands[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: TColors.light,
                          borderRadius: BorderRadius.circular(8),
                          image: brand.image.isNotEmpty && brand.image.startsWith('http')
                              ? DecorationImage(image: NetworkImage(brand.image), fit: BoxFit.contain)
                              : null,
                        ),
                        child: brand.image.isEmpty || !brand.image.startsWith('http')
                            ? const Icon(Iconsax.building, color: TColors.primary)
                            : null,
                      ),
                      title: Text(brand.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${brand.productsCount ?? 0} products'),
                      trailing: brand.isFeatured == true
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: TColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Iconsax.star, size: 12, color: TColors.warning),
                                  SizedBox(width: 4),
                                  Text('Featured', style: TextStyle(fontSize: 10, color: TColors.warning)),
                                ],
                              ),
                            )
                          : null,
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
                    TLoaders.customDialog(message: 'Uploading brands...');
                    
                    await brandRepo.uploadAllBrands(dummyBrands);
                    
                    TLoaders.hideDialog();
                    TLoaders.successSnackBar(
                      title: 'Success!',
                      message: '${dummyBrands.length} brands uploaded successfully',
                    );
                    
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                  } catch (e) {
                    TLoaders.hideDialog();
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to upload brands: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.arrow_up),
                label: const Text('Upload Default Brands'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Check Existing Brands Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final brands = await brandRepo.getAllBrands();
                    TLoaders.successSnackBar(
                      title: 'Info',
                      message: 'Found ${brands.length} brands in database',
                    );
                  } catch (e) {
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to fetch brands: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.search_status),
                label: const Text('Check Existing Brands'),
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