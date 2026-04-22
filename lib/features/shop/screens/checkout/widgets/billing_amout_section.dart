import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  double _calculateShipping(double subtotal) {
    // Free shipping above ₹50,000
    if (subtotal >= 50000) return 0;
    // Standard shipping based on order value
    if (subtotal >= 25000) return 99;
    if (subtotal >= 10000) return 149;
    if (subtotal >= 5000) return 199;
    if (subtotal >= 1000) return 299;
    return 399;
  }

  double _calculateTax(double subtotal) {
    // 5% GST
    return subtotal * 0.05;
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final checkoutController = Get.find<CheckoutController>();
    
    return Obx(() {
      final subTotal = cartController.totalCartPrice.value;
      final shipping = _calculateShipping(subTotal);
      final tax = _calculateTax(subTotal);
      final discount = checkoutController.discountAmount.value;
      final total = subTotal + shipping + tax - discount;

      return Column(
        children: [
          /// Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${subTotal.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),

          /// Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping', style: Theme.of(context).textTheme.bodyMedium),
              Text(shipping == 0 ? 'Free' : '₹${shipping.toStringAsFixed(0)}', 
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),

          /// Tax (GST)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GST (5%)', style: Theme.of(context).textTheme.bodyMedium),
              Text('₹${tax.toStringAsFixed(0)}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),

          /// Discount
          if (discount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    '- ₹${discount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

          /// Divider
          const Divider(),
          const SizedBox(height: 8),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleMedium),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ],
      );
    });
  }
}