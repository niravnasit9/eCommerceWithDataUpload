import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/abstract/products.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class LoadProductsScreen extends StatelessWidget {
  const LoadProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productRepo = Get.find<ProductRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Products'),
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
              'Upload Default Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'This will add the following default products to your Firebase database:',
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
                    _buildStatItem(Iconsax.shop, 'Total Products', dummyProducts.length.toString()),
                    _buildStatItem(Iconsax.tick_circle, 'Variable Type', dummyProducts.where((p) => p.productType == 'variable').length.toString()),
                    _buildStatItem(Iconsax.box, 'Single Type', dummyProducts.where((p) => p.productType == 'single').length.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// List of default products
            Expanded(
              child: ListView.builder(
                itemCount: dummyProducts.length,
                itemBuilder: (_, index) {
                  final product = dummyProducts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                    child: ListTile(
                      leading: const Icon(Iconsax.mobile, color: TColors.primary),
                      title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('₹${product.price} - Stock: ${product.stock}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.productType == 'variable' ? TColors.info : TColors.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.productType == 'variable' ? 'Variable' : 'Single',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
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
                    TLoaders.customDialog(message: 'Uploading products...');
                    
                    // Check if products already exist
                    final existing = await productRepo.productsAlreadyUploaded();
                    
                    if (existing) {
                      TLoaders.hideDialog();
                      TLoaders.warningSnackBar(
                        title: 'Warning',
                        message: 'Products already exist in database!',
                      );
                      return;
                    }
                    
                    await productRepo.syncNewProductsOnly();
                    
                    TLoaders.hideDialog();
                    TLoaders.successSnackBar(
                      title: 'Success!',
                      message: '${dummyProducts.length} products uploaded successfully',
                    );
                    
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                  } catch (e) {
                    TLoaders.hideDialog();
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to upload products: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.arrow_up),
                label: const Text('Upload Default Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            /// Check Existing Products Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final products = await productRepo.getAllProducts();
                    TLoaders.successSnackBar(
                      title: 'Info',
                      message: 'Found ${products.length} products in database',
                    );
                  } catch (e) {
                    TLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Failed to fetch products: $e',
                    );
                  }
                },
                icon: const Icon(Iconsax.search_status),
                label: const Text('Check Existing Products'),
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