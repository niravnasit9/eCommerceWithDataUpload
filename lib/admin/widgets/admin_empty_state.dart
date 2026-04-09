import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onActionPressed,
    this.actionText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onActionPressed;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: dark ? TColors.grey : TColors.darkGrey,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onActionPressed != null && actionText != null) ...[
            const SizedBox(height: TSizes.spaceBtwItems),
            ElevatedButton.icon(
              onPressed: onActionPressed,
              icon: const Icon(Iconsax.add),
              label: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}