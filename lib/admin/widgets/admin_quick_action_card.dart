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
    this.color = TColors.primary,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.sm),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.xs),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: dark ? TColors.white : TColors.black,
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}