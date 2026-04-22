import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:yt_ecommerce_admin_panel/data/load_data/load_banners.dart';
import 'package:yt_ecommerce_admin_panel/data/load_data/load_brands.dart';
import 'package:yt_ecommerce_admin_panel/data/load_data/load_coupons.dart';
import 'package:yt_ecommerce_admin_panel/data/load_data/load_products.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class LoadData extends StatefulWidget {
  const LoadData({super.key});

  @override
  State<LoadData> createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  bool _loadingBrands = false;
  bool _loadingProducts = false;
  bool _loadingBanners = false;
  bool _loadingCoupons = false;

  Future<void> _uploadBrands() async {
    if (_loadingBrands) return;
    setState(() => _loadingBrands = true);
    try {
      await Get.to(() => const LoadBrandsScreen());
    } finally {
      setState(() => _loadingBrands = false);
    }
  }

  Future<void> _uploadProducts() async {
    if (_loadingProducts) return;
    setState(() => _loadingProducts = true);
    try {
      await Get.to(() => const LoadProductsScreen());
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  Future<void> _uploadBanners() async {
    if (_loadingBanners) return;
    setState(() => _loadingBanners = true);
    try {
      await Get.to(() => const LoadBannersScreen());
    } finally {
      setState(() => _loadingBanners = false);
    }
  }

  Future<void> _uploadCoupons() async {
    if (_loadingCoupons) return;
    setState(() => _loadingCoupons = true);
    try {
      await Get.to(() => const LoadCouponsScreen());
    } finally {
      setState(() => _loadingCoupons = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Upload Data',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Record',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Column(
              children: [
                // ── Brands ──────────────────────────────────────────────────
                TSettingsMenuTile(
                  icon: Iconsax.shop,
                  title: 'Upload Brands',
                  subTitle: 'Adds default brands to database',
                  trailing: _loadingBrands
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.document_upload),
                  onTap: _loadingBrands ? null : _uploadBrands,
                ),

                // ── Products ─────────────────────────────────────────────────
                TSettingsMenuTile(
                  icon: Iconsax.shopping_cart,
                  title: 'Upload Products',
                  subTitle: 'Adds default products to database',
                  trailing: _loadingProducts
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.document_upload),
                  onTap: _loadingProducts ? null : _uploadProducts,
                ),

                // ── Banners ──────────────────────────────────────────────────
                TSettingsMenuTile(
                  icon: Iconsax.image,
                  title: 'Upload Banners',
                  subTitle: 'Adds default banners to database',
                  trailing: _loadingBanners
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.document_upload),
                  onTap: _loadingBanners ? null : _uploadBanners,
                ),

                // ── Coupons ──────────────────────────────────────────────────
                TSettingsMenuTile(
                  icon: Iconsax.discount_circle,
                  title: 'Upload Coupons',
                  subTitle: 'Adds default discount coupons to database',
                  trailing: _loadingCoupons
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.document_upload),
                  onTap: _loadingCoupons ? null : _uploadCoupons,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}