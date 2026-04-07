import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return ListTile(
      leading: Icon(
        dark ? Iconsax.moon : Iconsax.sun_1,
        color: dark ? TColors.primary : TColors.primary,
        size: 22,
      ),
      title: Text(
        dark ? 'Dark Mode' : 'Light Mode',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: dark ? TColors.white : TColors.black,
            ),
      ),
      trailing: Switch(
        value: dark,
        onChanged: (value) async {
          // Show feedback before changing theme
          Get.closeCurrentSnackbar();
          Get.snackbar(
            'Theme Changing',
            value ? 'Switching to Dark Mode...' : 'Switching to Light Mode...',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(milliseconds: 800),
            backgroundColor: value ? TColors.dark : TColors.white,
            colorText: value ? TColors.white : TColors.black,
            icon: Icon(
              value ? Iconsax.moon : Iconsax.sun_1,
              color: value ? TColors.warning : TColors.primary,
            ),
          );
          
          // Wait a moment then change theme
          await Future.delayed(const Duration(milliseconds: 300));
          
          if (value) {
            Get.changeThemeMode(ThemeMode.dark);
          } else {
            Get.changeThemeMode(ThemeMode.light);
          }
          
          // Show success message after theme change
          await Future.delayed(const Duration(milliseconds: 200));
          Get.closeCurrentSnackbar();
          Get.snackbar(
            'Theme Changed',
            value ? 'Dark Mode Activated 🌙' : 'Light Mode Activated ☀️',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: value ? TColors.dark : TColors.white,
            colorText: value ? TColors.white : TColors.black,
            icon: Icon(
              value ? Iconsax.moon : Iconsax.sun_1,
              color: value ? TColors.warning : TColors.primary,
            ),
          );
        },
        activeColor: TColors.primary,
        inactiveThumbColor: TColors.white,
        inactiveTrackColor: TColors.grey,
      ),
    );
  }
}