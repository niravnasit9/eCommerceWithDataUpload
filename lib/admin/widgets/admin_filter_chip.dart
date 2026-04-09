import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminFilterChip extends StatelessWidget {
  const AdminFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final chipColor = color ?? _getStatusColor(label);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: dark ? TColors.dark : TColors.white,
      selectedColor: chipColor.withOpacity(0.2),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : (dark ? TColors.white : TColors.black),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? chipColor
            : (dark ? TColors.borderSecondary : TColors.borderPrimary),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TColors.warning;
      case 'processing':
        return TColors.info;
      case 'confirmed':
        return TColors.success;
      case 'shipped':
        return TColors.primary;
      case 'out for delivery':
        return TColors.secondary;
      case 'delivered':
        return TColors.success;
      case 'cancelled':
        return TColors.error;
      case 'refunded':
        return TColors.warning;
      default:
        return TColors.primary;
    }
  }
}