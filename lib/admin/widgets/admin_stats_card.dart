import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = TColors.primary,
    this.trend,
    this.trendValue,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool? trend; // true = up (green), false = down (red)
  final String? trendValue; // e.g., "+12%", "-5%"
  final String? subtitle; // e.g., "vs last month"
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        splashColor: color.withOpacity(0.08),
        hoverColor: color.withOpacity(0.04),
        child: Ink(
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [
                      TColors.dark,
                      Color.alphaBlend(color.withOpacity(0.06), TColors.dark),
                    ]
                  : [
                      TColors.white,
                      Color.alphaBlend(color.withOpacity(0.04), TColors.white),
                    ],
            ),
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            border: Border.all(
              color: dark ? TColors.borderSecondary : TColors.borderPrimary,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(dark ? 0.08 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Icon and Trend Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Icon container
                  Container(
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius:
                          BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                    child: Icon(icon, size: 22, color: color),
                  ),

                  /// Trend pill
                  if (trend != null && trendValue != null)
                    _TrendPill(trend: trend!, value: trendValue!),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Value
              isLoading
                  ? Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: (dark ? Colors.white : Colors.black)
                            .withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    )
                  : Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: dark ? TColors.white : TColors.dark,
                            height: 1.1,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              const SizedBox(height: TSizes.xs),

              /// Title
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dark
                          ? TColors.textSecondary
                          : TColors.darkerGrey,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              /// Optional subtitle
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: dark
                            ? TColors.textSecondary.withOpacity(0.7)
                            : TColors.darkGrey,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.trend, required this.value});

  final bool trend;
  final String value;

  @override
  Widget build(BuildContext context) {
    final Color tone = trend ? TColors.success : TColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tone.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trend ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
            size: 11,
            color: tone,
          ),
          const SizedBox(width: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: tone,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}