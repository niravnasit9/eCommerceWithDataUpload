import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class AdminInfoRow extends StatelessWidget {
  const AdminInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.dark,
    this.statusColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool dark;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: TSizes.iconSm,
          color: dark ? TColors.textWhite : TColors.textSecondary,
        ),
        const SizedBox(width: TSizes.spaceBtwItems / 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: dark ? TColors.textWhite : TColors.textSecondary,
                    ),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: statusColor ?? (dark ? TColors.textWhite : TColors.textPrimary),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}