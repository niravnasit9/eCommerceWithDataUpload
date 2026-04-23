import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_order_controller.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/product_price_text.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/product_title_text.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  const AdminOrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  String _truncateString(String text, int maxLength) {
    if (text.isEmpty) return 'N/A';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'en_IN',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.printer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getStatusColor(order.status).withOpacity(0.1),
                    _getStatusColor(order.status).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: _getStatusColor(order.status).withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      size: TSizes.iconLg,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                  const SizedBox(width: TSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Status',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: dark ? TColors.textWhite : TColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: TSizes.xs),
                        Text(
                          order.orderStatusText.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: _getStatusColor(order.status),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: TSizes.xs),
                        Text(
                          _getStatusMessage(order.status),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: dark ? TColors.textWhite : TColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order Summary Section
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: dark ? TColors.textWhite : TColors.textPrimary,
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
                        _buildInfoRow(
                          context,
                          'Order ID',
                          _truncateString(order.id, 12),
                          Iconsax.tag,
                          dark,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'Order Date',
                          order.formattedOrderDate,
                          Iconsax.calendar,
                          dark,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'Payment Method',
                          order.paymentMethod,
                          Iconsax.card,
                          dark,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'Payment Status',
                          order.paymentStatus ?? 'Completed',
                          Iconsax.tick_circle,
                          dark,
                          statusColor: TColors.success,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'User ID',
                          _truncateString(order.userId, 12),
                          Iconsax.user,
                          dark,
                        ),
                        /// ✅ Add Coupon if applied
                        if (order.couponCode != null && order.couponCode!.isNotEmpty)
                          _buildInfoRow(
                            context,
                            'Coupon Applied',
                            order.couponCode!,
                            Iconsax.discount_circle,
                            dark,
                            statusColor: TColors.success,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Delivery Information Section
                  Text(
                    'Delivery Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: dark ? TColors.textWhite : TColors.textPrimary,
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
                        _buildInfoRow(
                          context,
                          'Expected Delivery',
                          order.formattedDeliveryDate,
                          Iconsax.truck,
                          dark,
                          statusColor: order.status == OrderStatus.delivered
                              ? TColors.success
                              : TColors.warning,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'Shipping Address',
                          '${order.address?.street}, ${order.address?.city}, ${order.address?.state} - ${order.address?.postalCode}',
                          Iconsax.location,
                          dark,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildInfoRow(
                          context,
                          'Contact Number',
                          order.address?.phoneNumber ?? 'Not provided',
                          Iconsax.call,
                          dark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Items Ordered Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items Ordered',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: dark ? TColors.textWhite : TColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: dark ? TColors.textWhite : TColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// List of Items
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                    itemBuilder: (_, index) {
                      final item = order.items[index];
                      return Container(
                        padding: const EdgeInsets.all(TSizes.sm),
                        decoration: BoxDecoration(
                          color: dark ? TColors.dark : TColors.white,
                          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                          border: Border.all(
                            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                          ),
                        ),
                        child: Row(
                          children: [
                            /// Product Image
                            TRoundedImage(
                              imageurl: item.image ?? '',
                              width: 70,
                              height: 70,
                              isNetworkImage: true,
                              padding: const EdgeInsets.all(TSizes.xs),
                              backgroundColor: dark ? TColors.dark : TColors.light,
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),

                            /// Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TProductTitleText(
                                    title: item.title,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: TSizes.xs),

                                  /// Attributes
                                  if (item.selectedVariation != null &&
                                      item.selectedVariation!.isNotEmpty)
                                    Wrap(
                                      spacing: TSizes.sm,
                                      runSpacing: TSizes.xs,
                                      children: item.selectedVariation!.entries.map((e) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: TSizes.sm,
                                            vertical: TSizes.xs,
                                          ),
                                          decoration: BoxDecoration(
                                            color: dark ? TColors.darkContainer : TColors.softGrey,
                                            borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                                          ),
                                          child: Text(
                                            '${e.key}: ${e.value}',
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: dark ? TColors.textWhite : TColors.textSecondary,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                  const SizedBox(height: TSizes.sm),

                                  /// Quantity and Price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: TSizes.sm,
                                          vertical: TSizes.xs,
                                        ),
                                        decoration: BoxDecoration(
                                          color: dark ? TColors.darkContainer : TColors.softGrey,
                                          borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                                        ),
                                        child: Text(
                                          'Qty: ${item.quantity}',
                                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                color: dark ? TColors.textWhite : TColors.textSecondary,
                                              ),
                                        ),
                                      ),
                                      TProductPriceText(
                                        price: (item.price * item.quantity).toStringAsFixed(0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Payment Summary Section - ✅ UPDATED with proper breakdown
                  Text(
                    'Payment Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: dark ? TColors.textWhite : TColors.textPrimary,
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
                        /// Subtotal
                        _buildSummaryRow(
                          context,
                          'Subtotal',
                          currencyFormat.format(order.subtotal ?? order.totalAmount),
                          dark,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        
                        /// Shipping
                        _buildSummaryRow(
                          context,
                          'Shipping',
                          (order.shippingCost ?? 0) == 0 ? 'Free' : currencyFormat.format(order.shippingCost ?? 0),
                          dark,
                          isFree: (order.shippingCost ?? 0) == 0,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        
                        /// Tax
                        _buildSummaryRow(
                          context,
                          'Tax (GST 5%)',
                          currencyFormat.format(order.taxAmount ?? 0),
                          dark,
                        ),
                        
                        /// Discount (if applied)
                        if ((order.discountAmount ?? 0) > 0) ...[
                          const SizedBox(height: TSizes.spaceBtwItems),
                          _buildSummaryRow(
                            context,
                            'Discount',
                            '-${currencyFormat.format(order.discountAmount ?? 0)}',
                            dark,
                            isDiscount: true,
                          ),
                        ],
                        
                        const Divider(height: TSizes.spaceBtwSections),
                        
                        /// Total Amount
                        _buildSummaryRow(
                          context,
                          'Total Amount',
                          currencyFormat.format(order.totalAmount),
                          dark,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Status Update Section
                  if (order.status != OrderStatus.delivered &&
                      order.status != OrderStatus.cancelled)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Order Status',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _updateStatus(context, 'Confirmed');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.info,
                                  ),
                                  child: const Text('Confirm'),
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _updateStatus(context, 'Shipped');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                  ),
                                  child: const Text('Ship'),
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _updateStatus(context, 'Delivered');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.success,
                                  ),
                                  child: const Text('Deliver'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                _updateStatus(context, 'Cancelled');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: TColors.error,
                                side: const BorderSide(color: TColors.error),
                              ),
                              child: const Text('Cancel Order'),
                            ),
                          ),
                        ],
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

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool dark, {
    Color? statusColor,
  }) {
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool dark, {
    bool isFree = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isTotal
                    ? TColors.primary
                    : (dark ? TColors.textWhite : TColors.textSecondary),
                fontWeight: isTotal ? FontWeight.bold : null,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDiscount
                    ? TColors.success
                    : (isFree
                        ? TColors.success
                        : (isTotal
                            ? TColors.primary
                            : (dark ? TColors.textWhite : TColors.textPrimary))),
                fontWeight: isDiscount || isTotal ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }

  void _updateStatus(BuildContext context, String newStatus) {
    Get.back();
    final controller = Get.find<AdminOrderController>();
    controller.updateOrderStatus(order.id, newStatus);
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TColors.warning;
      case OrderStatus.confirmed:
        return TColors.info;
      case OrderStatus.shipped:
        return TColors.primary;
      case OrderStatus.outForDelivery:
        return TColors.secondary;
      case OrderStatus.delivered:
        return TColors.success;
      case OrderStatus.cancelled:
        return TColors.error;
      case OrderStatus.refunded:
        return TColors.darkGrey;
      default:
        return TColors.primary;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Iconsax.clock;
      case OrderStatus.confirmed:
        return Iconsax.tick_circle;
      case OrderStatus.shipped:
        return Iconsax.ship;
      case OrderStatus.outForDelivery:
        return Iconsax.truck;
      case OrderStatus.delivered:
        return Iconsax.tick_circle;
      case OrderStatus.cancelled:
        return Iconsax.close_circle;
      case OrderStatus.refunded:
        return Iconsax.money_recive;
      default:
        return Iconsax.box;
    }
  }

  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Awaiting confirmation from the store';
      case OrderStatus.confirmed:
        return 'Order confirmed and being processed';
      case OrderStatus.shipped:
        return 'Order has been shipped';
      case OrderStatus.outForDelivery:
        return 'Order is out for delivery';
      case OrderStatus.delivered:
        return 'Order delivered successfully';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
      case OrderStatus.refunded:
        return 'Payment has been refunded';
      default:
        return 'Status update pending';
    }
  }
}