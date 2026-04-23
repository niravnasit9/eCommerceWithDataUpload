import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/product_price_text.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/product_title_text.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order Status Banner
            _buildStatusBanner(context, dark),

            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order Summary
                  _buildOrderSummary(context, dark),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Delivery Information
                  _buildDeliveryInfo(context, dark),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Items Ordered
                  _buildItemsList(context, dark),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Payment Summary (with breakdown)
                  _buildPaymentSummary(context, dark),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Help Section
                  _buildHelpSection(context, dark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context, bool dark) {
    return Container(
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
    );
  }

  Widget _buildOrderSummary(BuildContext context, bool dark) {
    return Container(
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
          _buildInfoRow(context, 'Order ID', order.id.substring(0, 12),
              Iconsax.tag, dark),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildInfoRow(context, 'Order Date', order.formattedOrderDate,
              Iconsax.calendar, dark),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildInfoRow(context, 'Payment Method', order.paymentMethod,
              Iconsax.card, dark),
          if (order.couponCode != null && order.couponCode!.isNotEmpty)
            _buildInfoRow(context, 'Coupon Used', order.couponCode!,
                Iconsax.discount_circle, dark,
                statusColor: TColors.success),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(BuildContext context, bool dark) {
    return Container(
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
    );
  }

  Widget _buildItemsList(BuildContext context, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items Ordered (${order.items.length})',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.items.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: TSizes.spaceBtwItems),
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
                  TRoundedImage(
                    imageurl: item.image ?? '',
                    width: 70,
                    height: 70,
                    isNetworkImage: true,
                    padding: const EdgeInsets.all(TSizes.xs),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to product detail
                          },
                          child:
                              TProductTitleText(title: item.title, maxLines: 2),
                        ),
                        const SizedBox(height: TSizes.xs),
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
                                  color: dark
                                      ? TColors.darkContainer
                                      : TColors.softGrey,
                                  borderRadius: BorderRadius.circular(
                                      TSizes.borderRadiusSm),
                                ),
                                child: Text(
                                  '${e.key}: ${e.value}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: TSizes.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${item.quantity}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TProductPriceText(
                              price: (item.price * item.quantity)
                                  .toStringAsFixed(0),
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
      ],
    );
  }

  /// Payment Summary Section - Updated with proper breakdown
  Widget _buildPaymentSummary(BuildContext context, bool dark) {
    // Get values from order with fallbacks
    final subtotal = order.subtotal ?? order.totalAmount;
    final shipping = order.shippingCost ?? 0;
    final tax = order.taxAmount ?? 0;
    final discount = order.discountAmount ?? 0;
    final total = order.totalAmount;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${subtotal.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping', style: Theme.of(context).textTheme.bodyMedium),
              Text(shipping == 0 ? 'Free' : '₹${shipping.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Tax (GST)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GST (5%)', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${tax.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),

          /// Discount (if applied)
          if (discount > 0) ...[
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '- ₹${discount.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],

          const Divider(height: TSizes.spaceBtwSections),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleMedium),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: dark ? TColors.borderSecondary : TColors.borderPrimary,
        ),
      ),
      child: Row(
        children: [
          Icon(Iconsax.message_question,
              size: TSizes.iconMd, color: TColors.primary),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  'Contact our support team for any queries about your order',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      IconData icon, bool dark,
      {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon,
            size: TSizes.iconSm,
            color: dark ? TColors.textWhite : TColors.textSecondary),
        const SizedBox(width: TSizes.spaceBtwItems / 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: dark ? TColors.textWhite : TColors.textSecondary,
                      )),
              const SizedBox(height: TSizes.xs),
              Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: statusColor ??
                            (dark ? TColors.textWhite : TColors.textPrimary),
                      )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
      BuildContext context, String label, String value, bool dark,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isTotal
                      ? TColors.primary
                      : (dark ? TColors.textWhite : TColors.textSecondary),
                  fontWeight: isTotal ? FontWeight.bold : null,
                )),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDiscount
                      ? TColors.success
                      : (isTotal
                          ? TColors.primary
                          : (dark ? TColors.textWhite : TColors.textPrimary)),
                  fontWeight: isDiscount || isTotal ? FontWeight.bold : null,
                )),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return TColors.warning;
      case OrderStatus.processing:
        return TColors.info;
      case OrderStatus.confirmed:
        return TColors.success;
      case OrderStatus.shipped:
        return TColors.primary;
      case OrderStatus.outForDelivery:
        return TColors.secondary;
      case OrderStatus.delivered:
        return TColors.success;
      case OrderStatus.cancelled:
        return TColors.error;
      default:
        return TColors.primary;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Iconsax.clock;
      case OrderStatus.processing:
        return Iconsax.repeat;
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
      default:
        return Iconsax.box;
    }
  }

  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Your order has been received and is pending confirmation';
      case OrderStatus.processing:
        return 'Your order is being processed';
      case OrderStatus.confirmed:
        return 'Your order has been confirmed';
      case OrderStatus.shipped:
        return 'Your order has been shipped';
      case OrderStatus.outForDelivery:
        return 'Your order is out for delivery';
      case OrderStatus.delivered:
        return 'Your order has been delivered';
      case OrderStatus.cancelled:
        return 'Your order has been cancelled';
      default:
        return 'Status update pending';
    }
  }
}
