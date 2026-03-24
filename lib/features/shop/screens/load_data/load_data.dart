import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:yt_ecommerce_admin_panel/data/abstract/brands.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/brnads/brand_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
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
  String _loadingLabel = '';

  // ─── Helper: show full-screen blocking progress overlay ───────────────────
  void _showLoadingOverlay(String label) {
    setState(() => _loadingLabel = label);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _hideLoadingOverlay() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // ─── UPLOAD BRANDS ────────────────────────────────────────────────────────
  Future<void> _uploadBrands() async {
    if (_loadingBrands) return;
    setState(() => _loadingBrands = true);
    _showLoadingOverlay('Syncing Brands\nPlease wait...');
    try {
      await BrandRepository.instance.uploadAllBrands(dummyBrands);
      _hideLoadingOverlay();
      Get.snackbar(
        'Success',
        'New brands added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      _hideLoadingOverlay();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loadingBrands = false);
    }
  }

  // ─── UPLOAD PRODUCTS ──────────────────────────────────────────────────────
  Future<void> _uploadProducts() async {
    if (_loadingProducts) return;
    setState(() => _loadingProducts = true);
    _showLoadingOverlay('Syncing Products\nThis may take a while...');
    try {
      await ProductRepository.instance.syncNewProductsOnly();
      _hideLoadingOverlay();
      Get.snackbar(
        'Success',
        'New products added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      _hideLoadingOverlay();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loadingProducts = false);
    }
  }

  // ─── UPLOAD BANNERS ───────────────────────────────────────────────────────
  Future<void> _uploadBanners() async {
    if (_loadingBanners) return;
    setState(() => _loadingBanners = true);
    _showLoadingOverlay('Syncing Banners\nPlease wait...');
    try {
      await BannerRepository.instance.syncNewBannersOnly();
      _hideLoadingOverlay();
      Get.snackbar(
        'Success',
        'New banners added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
      );
    } catch (e) {
      _hideLoadingOverlay();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loadingBanners = false);
    }
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────
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
                  subTitle: 'Adds only new brands, skips existing ones',
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
                  subTitle: 'Adds only new products, skips existing ones',
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
                  subTitle: 'Adds only new banners, skips existing ones',
                  trailing: _loadingBanners
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Iconsax.document_upload),
                  onTap: _loadingBanners ? null : _uploadBanners,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
