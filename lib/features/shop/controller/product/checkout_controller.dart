import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/payment_method_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value =
        PaymentMethodModel(name: 'Razorpay', image: TImages.razorpay); // use any icon
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(
                title: "Select Payment method",
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// ✅ Razorpay
              TPaymetTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Razorpay',
                  image: TImages.razorpay,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems / 2),

              /// ✅ COD
              TPaymetTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Cash on Delivery',
                  image: TImages.cod, // add this image
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
// class CheckoutController extends GetxController {
//   static CheckoutController get instance => Get.find();

//   final Rx<PaymentMethodModel> selectedPaymentMethod =
//       PaymentMethodModel.empty().obs;

//   @override
//   void onInit() {
//     selectedPaymentMethod.value =
//         PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay);
//     super.onInit();
//   }

//   Future<dynamic> selectPaymentMethod(BuildContext context) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (_) => SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(TSizes.lg),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const TSectionHeading(
//                 title: "Select Payment method",
//                 showActionButton: false,
//               ),
//               const SizedBox(
//                 height: TSizes.spaceBtwSections,
//               ),
//               TPaymetTile(
//                   paymentMethod: PaymentMethodModel(
//                       name: 'Paypal', image: TImages.paypal)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod: PaymentMethodModel(
//                       name: 'Google Pay', image: TImages.googlePay)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod: PaymentMethodModel(
//                       name: 'Apple Pay', image: TImages.applePay)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod:
//                       PaymentMethodModel(name: 'Visa', image: TImages.visa)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod: PaymentMethodModel(
//                       name: 'Master Card', image: TImages.masterCard)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod:
//                       PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               TPaymetTile(
//                   paymentMethod: PaymentMethodModel(
//                       name: 'Credit Card', image: TImages.creditCard)),
//               const SizedBox(
//                 height: TSizes.spaceBtwItems / 2,
//               ),
//               const SizedBox(
//                 height: TSizes.spaceBtwSections,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
