import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_coupons.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_products.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_brands.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_banners.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_orders.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_users.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_navigation_menu.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/settings/widgets/theme_toggle.dart';
import 'package:yt_ecommerce_admin_panel/data/load_data/load_data.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final authRepo = AuthenticationRepository.instance;
    final user = authRepo.authUser;

    return SafeArea(
      child: Drawer(
        width: 280,
        child: Column(
          children: [
            /// Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: const BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(TSizes.borderRadiusLg),
                  bottomRight: Radius.circular(TSizes.borderRadiusLg),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColors.white,
                      border: Border.all(color: TColors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        user?.email?[0].toUpperCase() ?? 'A',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    user?.email?.split('@')[0] ?? 'Admin',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: TColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: TSizes.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.sm,
                      vertical: TSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusLg),
                    ),
                    child: Text(
                      'Administrator',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: TColors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.chart_21,
                    title: 'Dashboard',
                    onTap: () {
                      Get.offAll(() => const AdminNavigationMenu());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.shop,
                    title: 'Products',
                    onTap: () {
                      Get.to(() => const AdminProducts());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.tag,
                    title: 'Brands',
                    onTap: () {
                      Get.to(() => const AdminBrands());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.image,
                    title: 'Banners',
                    onTap: () {
                      Get.to(() => const AdminBanners());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.shopping_cart,
                    title: 'Orders',
                    onTap: () {
                      Get.to(() => const AdminOrders());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.user,
                    title: 'Users',
                    onTap: () {
                      Get.to(() => const AdminUsers());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.discount_circle,
                    title: 'Coupons',
                    onTap: () {
                      Get.to(() => const AdminCoupons());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.data,
                    title: 'Upload Data',
                    onTap: () {
                      Get.to(() => const LoadData());
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.profile_circle,
                    title: 'My Profile',
                    onTap: () {
                      Get.to(() => const AdminDrawer());
                    },
                  ),
                  const Divider(height: TSizes.spaceBtwSections),

                  /// App Settings Section
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.setting_2,
                    title: 'App Settings',
                    onTap: () {},
                  ),

                  /// Theme Toggle
                  const ThemeToggle(),

                  const Divider(height: TSizes.spaceBtwSections),

                  /// Logout
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.logout,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () async {
                      await authRepo.logout();
                    },
                  ),
                ],
              ),
            ),

            /// Footer
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Text(
                'I-Store Admin Panel v1.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: dark ? TColors.grey : TColors.darkGrey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final dark = THelperFunctions.isDarkMode(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? TColors.error
            : (dark ? TColors.white : TColors.black),
        size: 22,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDestructive
                  ? TColors.error
                  : (dark ? TColors.white : TColors.black),
            ),
      ),
      trailing: Icon(
        Iconsax.arrow_right_3,
        size: 18,
        color: dark ? TColors.white : TColors.black,
      ),
      onTap: onTap,
    );
  }
}
