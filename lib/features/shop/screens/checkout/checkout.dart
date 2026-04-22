import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/products/cart/coupon_widget.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/order_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/billing_amout_section.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  double _calculateShipping(double subtotal) {
    if (subtotal >= 50000) return 0;
    if (subtotal >= 25000) return 99;
    if (subtotal >= 10000) return 149;
    if (subtotal >= 5000) return 199;
    if (subtotal >= 1000) return 299;
    return 399;
  }

  double _calculateTax(double subtotal) {
    return subtotal * 0.05;
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final cartController = Get.find<CartController>();
    final checkoutController = Get.find<CheckoutController>();
    final orderController = Get.find<OrderController>();
    
    return Scaffold(
      appBar: TAppBar(
        title: Text('Order Review',
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Items in Cart
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Coupon TextField
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Billing Section
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                showBorder: true,
                backgroundColor: dark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    /// Pricing
                    TBillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    /// Divider
                    Divider(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    /// Payment Method
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    /// Address
                    TBillingAddressSection(),
                    SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// Checkout Button
      bottomNavigationBar: Obx(() {
        final subTotal = cartController.totalCartPrice.value;
        final shipping = _calculateShipping(subTotal);
        final tax = _calculateTax(subTotal);
        final discount = checkoutController.discountAmount.value;
        final totalAmount = subTotal + shipping + tax - discount;
        
        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: subTotal > 0
                ? () {
                    final method = checkoutController.selectedPaymentMethod.value.name;

                    if (method == 'Razorpay') {
                      orderController.processOrder(totalAmount);
                    } else if (method == 'Cash on Delivery') {
                      orderController.processCODOrder(totalAmount);
                    } else {
                      TLoaders.warningSnackBar(
                        title: 'Select Payment Method',
                        message: 'Please select a valid payment method.',
                      );
                    }
                  }
                : () {
                    TLoaders.warningSnackBar(
                      title: 'Empty Cart',
                      message: 'Add items to the cart in order to proceed.',
                    );
                  },
            child: Text('Pay ₹${totalAmount.toStringAsFixed(0)}'),
          ),
        );
      }),
    );
  }
}