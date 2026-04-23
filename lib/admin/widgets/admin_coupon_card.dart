import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminCouponCard extends StatelessWidget {
  const AdminCouponCard({
    super.key,
    required this.coupon,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final CouponModel coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final isExpired = coupon.isExpired;
    final isActive = coupon.isActive && !isExpired;
    final daysLeft = (coupon.validTo.difference(DateTime.now()).inDays);
    final usagePercentage = coupon.usageLimit > 0
        ? (coupon.usedCount / coupon.usageLimit) * 100
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: isActive
              ? TColors.primary
              : (isExpired ? TColors.error : TColors.warning),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Status Badge
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: isActive
                  ? TColors.primary.withOpacity(0.05)
                  : (isExpired
                      ? TColors.error.withOpacity(0.05)
                      : TColors.warning.withOpacity(0.05)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TSizes.borderRadiusMd),
                topRight: Radius.circular(TSizes.borderRadiusMd),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Coupon Code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.code,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? TColors.primary
                              : (isExpired ? TColors.error : TColors.warning),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        coupon.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                /// Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? TColors.success.withOpacity(0.1)
                        : (isExpired
                            ? TColors.error.withOpacity(0.1)
                            : TColors.warning.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive
                            ? Iconsax.tick_circle
                            : (isExpired
                                ? Iconsax.clock
                                : Iconsax.close_circle),
                        size: 14,
                        color: isActive
                            ? TColors.success
                            : (isExpired ? TColors.error : TColors.warning),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isActive
                            ? 'Active'
                            : (isExpired ? 'Expired' : 'Inactive'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? TColors.success
                              : (isExpired ? TColors.error : TColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Main Content
          Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Discount Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TColors.primary.withOpacity(0.1),
                        TColors.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.discount_circle,
                        size: 24,
                        color: TColors.primary,
                      ),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        coupon.discountText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Requirements Row
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.money,
                        label: 'Min Order',
                        value: coupon.minimumOrderAmount != null
                            ? '₹${coupon.minimumOrderAmount!.toInt()}'
                            : 'No minimum',
                        color: TColors.warning,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.receipt,
                        label: 'Usage Limit',
                        value: coupon.usageLimit == 0
                            ? 'Unlimited'
                            : '${coupon.usageLimit}',
                        color: TColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.sm),

                /// Usage Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.repeat,
                        label: 'Times Used',
                        value: '${coupon.usedCount}',
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.profile_2user,
                        label: 'Unique Users',
                        value: '${coupon.usedByUsers.length}',
                        color: TColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.sm),

                // Add this after the Usage Stats section

                /// Users who used this coupon
                /// Users who used this coupon
                if (coupon.usedByUsers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: TSizes.sm),
                      Container(
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: dark ? TColors.darkerGrey : TColors.softGrey,
                          borderRadius:
                              BorderRadius.circular(TSizes.borderRadiusMd),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Iconsax.user,
                                    size: 14, color: TColors.info),
                                const SizedBox(width: 4),
                                Text(
                                  'Used by ${coupon.usedByUsers.length} user(s)',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: coupon.usedByUsers.map((userId) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: TColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _truncateUserId(
                                        userId), // ✅ Using the truncate method
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: TColors.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                /// Progress Bar for usage limit
                if (coupon.usageLimit > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Usage Progress',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            '${coupon.usedCount}/${coupon.usageLimit} (${usagePercentage.toStringAsFixed(0)}%)',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: usagePercentage / 100,
                          backgroundColor:
                              dark ? TColors.darkerGrey : TColors.softGrey,
                          color: usagePercentage > 80
                              ? TColors.error
                              : (usagePercentage > 50
                                  ? TColors.warning
                                  : TColors.success),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: TSizes.sm),

                /// Validity Row
                Container(
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    color: dark ? TColors.darkerGrey : TColors.softGrey,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.calendar,
                            size: 14,
                            color:
                                isExpired ? TColors.error : TColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Valid: ${_formatDate(coupon.validFrom)} - ${_formatDate(coupon.validTo)}',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  isExpired ? TColors.error : TColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      if (!isExpired && isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: daysLeft < 7
                                ? TColors.error.withOpacity(0.1)
                                : TColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            daysLeft < 7
                                ? 'Expires in ${daysLeft}d'
                                : '${daysLeft} days left',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: daysLeft < 7
                                  ? TColors.error
                                  : TColors.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Action Buttons
          Divider(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm, vertical: TSizes.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Iconsax.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Iconsax.trash, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: TColors.error,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Active'),
                    const SizedBox(width: 8),
                    Switch(
                      value: coupon.isActive,
                      onChanged: (_) => onToggleStatus(),
                      activeColor: TColors.success,
                      inactiveThumbColor: TColors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(TSizes.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 2),
              Text(
                label,
                style: TextStyle(fontSize: 9, color: color),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Helper method to truncate user ID for display
  String _truncateUserId(String userId) {
    if (userId.isEmpty) return 'Unknown';
    if (userId.length <= 10) return userId;
    return '${userId.substring(0, 6)}...${userId.substring(userId.length - 4)}';
  }
}
