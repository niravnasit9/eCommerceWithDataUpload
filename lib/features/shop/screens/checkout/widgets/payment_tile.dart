import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/payment_method_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class TPaymentTile extends StatelessWidget {
  const TPaymentTile({
    super.key,
    required this.paymentMethod,
  });

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<CheckoutController>();

    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.selectedPaymentMethod.value = paymentMethod;
          Get.back(); // Close the bottom sheet
        },
        child: TRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.dark : TColors.white,
          borderColor: controller.selectedPaymentMethod.value.name == paymentMethod.name
              ? TColors.primary
              : Colors.transparent,
          child: Row(
            children: [
              /// Radio Button
              SizedBox(
                width: 20,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: controller.selectedPaymentMethod.value.name == paymentMethod.name
                          ? TColors.primary
                          : dark
                              ? TColors.borderSecondary
                              : TColors.borderPrimary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: controller.selectedPaymentMethod.value.name == paymentMethod.name
                        ? Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: TColors.primary,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              /// Image
              TRoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? TColors.light : TColors.white,
                padding: const EdgeInsets.all(TSizes.sm),
                child: Image(
                  image: AssetImage(paymentMethod.image),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Iconsax.card, size: 20),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              /// Title
              Text(
                paymentMethod.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}