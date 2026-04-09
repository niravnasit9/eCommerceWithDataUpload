import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminQuickActionCard extends StatelessWidget {
  const AdminQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          border: Border.all(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: TColors.primary),
            const SizedBox(height: TSizes.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}