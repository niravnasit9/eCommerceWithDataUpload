import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/settings/widgets/theme_toggle.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// App Settings
            Text(
              'App Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
              ),
              child: Column(
                children: [
                  const ThemeToggle(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.notification),
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive order and product alerts'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: TColors.primary,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.language_square),
                    title: const Text('Language'),
                    subtitle: const Text('English (US)'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Store Settings
            Text(
              'Store Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.shop),
                    title: const Text('Store Information'),
                    subtitle: const Text('Update store name, logo, contact'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.money),
                    title: const Text('Payment Settings'),
                    subtitle: const Text('Configure payment methods'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.truck),
                    title: const Text('Shipping Settings'),
                    subtitle: const Text('Configure shipping zones and rates'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.discount_circle),
                    title: const Text('Tax Settings'),
                    subtitle: const Text('Configure tax rates'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// Email Settings
            Text(
              'Email Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.white,
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                border: Border.all(
                  color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.sms),
                    title: const Text('SMTP Configuration'),
                    subtitle: const Text('Configure email server settings'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Iconsax.tick_circle),
                    title: const Text('Order Confirmation Email'),
                    subtitle: const Text('Email sent after order placement'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: TColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}