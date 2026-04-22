import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/payment_method_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/payment_tile.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  // Coupon related
  final Rx<CouponModel?> appliedCoupon = Rx<CouponModel?>(null);
  final discountAmount = 0.0.obs;
  final couponCode = ''.obs;
  final availableCoupons = <CouponModel>[].obs;
  final isLoadingCoupons = false.obs;
  final searchResults = <CouponModel>[].obs;
  final TextEditingController couponController = TextEditingController();

  late final CouponRepository _couponRepository;
  late final CartController _cartController;

  @override
  void onInit() {
    super.onInit();

    _couponRepository = Get.find<CouponRepository>();
    _cartController = Get.find<CartController>();

    selectedPaymentMethod.value =
        PaymentMethodModel(name: 'Razorpay', image: TImages.razorpay);

    // Fetch coupons when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAvailableCoupons();
    });
  }

  /// Search coupons based on user input
  void searchCoupons(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.value = availableCoupons.where((coupon) {
      return coupon.code.toLowerCase().contains(query.toLowerCase()) ||
          coupon.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Fetch available coupons based on cart total
  Future<void> fetchAvailableCoupons() async {
    try {
      isLoadingCoupons.value = true;
      print('🔄 Fetching available coupons...');

      // Get all active coupons
      final allCoupons = await _couponRepository.getActiveCoupons();
      print('📦 Total active coupons found: ${allCoupons.length}');

      final cartTotal = _cartController.totalCartPrice.value;
      print('🛒 Cart total: ₹${cartTotal.toStringAsFixed(0)}');

      // Show ALL coupons that are active and valid (not just applicable)
      // But mark which ones are applicable
      availableCoupons.value = allCoupons;

      print('🎯 Total coupons to display: ${availableCoupons.value.length}');
      for (var coupon in availableCoupons.value) {
        final isApplicable = coupon.minimumOrderAmount == null ||
            cartTotal >= coupon.minimumOrderAmount!;
        print(
            '   - ${coupon.code}: Min ₹${coupon.minimumOrderAmount ?? 0} -> ${isApplicable ? "✅ Applicable" : "❌ Not applicable"}');
      }

      isLoadingCoupons.value = false;
    } catch (e) {
      isLoadingCoupons.value = false;
      print('❌ Error fetching coupons: $e');
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to load coupons: $e');
    }
  }

  /// Apply coupon
  Future<void> applyCoupon(String code) async {
    try {
      final cartTotal = _cartController.totalCartPrice.value;
      final coupon = await _couponRepository.validateCoupon(code, cartTotal);

      if (coupon != null) {
        appliedCoupon.value = coupon;
        discountAmount.value = coupon.calculateDiscount(cartTotal);
        couponCode.value = code;
        couponController.clear();
        searchResults.clear();
        TLoaders.successSnackBar(
            title: 'Coupon Applied!',
            message: '${coupon.discountText} discount applied');
      } else {
        TLoaders.errorSnackBar(
            title: 'Invalid Coupon', message: 'Coupon is invalid or expired');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to apply coupon');
    }
  }

  /// Apply coupon from suggestion
  Future<void> applySuggestedCoupon(CouponModel coupon) async {
    appliedCoupon.value = coupon;
    discountAmount.value =
        coupon.calculateDiscount(_cartController.totalCartPrice.value);
    couponCode.value = coupon.code;
    couponController.clear();
    searchResults.clear();
    TLoaders.successSnackBar(
        title: 'Coupon Applied!',
        message: '${coupon.discountText} discount applied');
  }

  /// Remove applied coupon
  void removeCoupon() {
    appliedCoupon.value = null;
    discountAmount.value = 0;
    couponCode.value = '';
    TLoaders.successSnackBar(
        title: 'Coupon Removed', message: 'Coupon has been removed');
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
              TPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Razorpay',
                  image: TImages.razorpay,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Cash on Delivery',
                  image: TImages.cod,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    couponController.dispose();
    searchResults.clear();
    super.onClose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
// import 'package:yt_ecommerce_admin_panel/data/repositories/orders/coupon_repository.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/models/payment_method_model.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/widgets/payment_tile.dart';
// import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
// import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
// import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

// class CheckoutController extends GetxController {
//   static CheckoutController get instance => Get.find();

//   final Rx<PaymentMethodModel> selectedPaymentMethod =
//       PaymentMethodModel.empty().obs;
//   final appliedCoupon = Rx<CouponModel?>(null);
//   final discountAmount = 0.0.obs;
//   final couponCode = ''.obs;

//   @override
//   void onInit() {
//     selectedPaymentMethod.value =
//         PaymentMethodModel(name: 'Razorpay', image: TImages.razorpay);
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
//               const SizedBox(height: TSizes.spaceBtwSections),

//               /// ✅ Razorpay
//               TPaymetTile(
//                 paymentMethod: PaymentMethodModel(
//                   name: 'Razorpay',
//                   image: TImages.razorpay,
//                 ),
//               ),

//               const SizedBox(height: TSizes.spaceBtwItems / 2),

//               /// ✅ COD
//               TPaymetTile(
//                 paymentMethod: PaymentMethodModel(
//                   name: 'Cash on Delivery',
//                   image: TImages.cod,
//                 ),
//               ),

//               const SizedBox(height: TSizes.spaceBtwSections),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Add these methods
//   Future<void> applyCoupon(String code, double orderAmount) async {
//     try {
//       final couponRepo = Get.find<CouponRepository>();
//       final coupon = await couponRepo.validateCoupon(code, orderAmount);
//       if (coupon != null) {
//         appliedCoupon.value = coupon;
//         discountAmount.value = coupon.calculateDiscount(orderAmount);
//         couponCode.value = code;
//         TLoaders.successSnackBar(
//             title: 'Coupon Applied',
//             message: '${coupon.discountText} discount applied');
//       } else {
//         TLoaders.errorSnackBar(
//             title: 'Invalid Coupon', message: 'Coupon is invalid or expired');
//       }
//     } catch (e) {
//       TLoaders.errorSnackBar(title: 'Error', message: 'Failed to apply coupon');
//     }
//   }

//   void removeCoupon() {
//     appliedCoupon.value = null;
//     discountAmount.value = 0;
//     couponCode.value = '';
//     TLoaders.successSnackBar(
//         title: 'Coupon Removed', message: 'Coupon has been removed');
//   }

// // Update getFinalTotal method if you have one
//   double getFinalTotal(double subtotal) {
//     return subtotal - discountAmount.value;
//   }
// }
// // class CheckoutController extends GetxController {
// //   static CheckoutController get instance => Get.find();

// //   final Rx<PaymentMethodModel> selectedPaymentMethod =
// //       PaymentMethodModel.empty().obs;

// //   @override
// //   void onInit() {
// //     selectedPaymentMethod.value =
// //         PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay);
// //     super.onInit();
// //   }

// //   Future<dynamic> selectPaymentMethod(BuildContext context) {
// //     return showModalBottomSheet(
// //       context: context,
// //       builder: (_) => SingleChildScrollView(
// //         child: Container(
// //           padding: const EdgeInsets.all(TSizes.lg),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const TSectionHeading(
// //                 title: "Select Payment method",
// //                 showActionButton: false,
// //               ),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwSections,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod: PaymentMethodModel(
// //                       name: 'Paypal', image: TImages.paypal)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod: PaymentMethodModel(
// //                       name: 'Google Pay', image: TImages.googlePay)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod: PaymentMethodModel(
// //                       name: 'Apple Pay', image: TImages.applePay)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod:
// //                       PaymentMethodModel(name: 'Visa', image: TImages.visa)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod: PaymentMethodModel(
// //                       name: 'Master Card', image: TImages.masterCard)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod:
// //                       PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               TPaymetTile(
// //                   paymentMethod: PaymentMethodModel(
// //                       name: 'Credit Card', image: TImages.creditCard)),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwItems / 2,
// //               ),
// //               const SizedBox(
// //                 height: TSizes.spaceBtwSections,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
