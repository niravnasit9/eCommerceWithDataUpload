import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/success_screen/success_screen.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/coupons/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/order_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/address_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:yt_ecommerce_admin_panel/navigation_menu.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    if (!Get.isRegistered<OrderController>()) {
      Get.lazyPut(() => OrderController());
    }
    return Get.find<OrderController>();
  }

  // Get dependencies
  CartController get cartController => Get.find<CartController>();
  AddressController get addressController => Get.find<AddressController>();
  CheckoutController get checkoutController => Get.find<CheckoutController>();
  OrderRepository get orderRepository => Get.find<OrderRepository>();
  CouponRepository get _coupenRepository => Get.find<CouponRepository>();
  AuthenticationRepository get authRepository =>
      Get.find<AuthenticationRepository>();

  late Razorpay _razorpay;
  final RxBool isProcessingPayment = false.obs;

  /// Store pending order
  OrderModel? _pendingOrder;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  /// Calculate shipping based on subtotal
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

  /// Calculate final total (subtotal + shipping + tax - discount)
  double _calculateFinalTotal(double subtotal, double discount) {
    final shipping = _calculateShipping(subtotal);
    final tax = _calculateTax(subtotal);
    return subtotal + shipping + tax - discount;
  }

  Future<void> _incrementCouponUsage() async {
    try {
      final couponId = checkoutController.appliedCouponId.value;
      final userId = authRepository.authUser?.uid;

      if (couponId.isNotEmpty && userId != null) {
        final couponRepo = Get.find<CouponRepository>();
        await couponRepo.incrementUsageCount(couponId, userId);
        print('✅ Coupon usage incremented for: $couponId');
      }
    } catch (e) {
      print('❌ Error incrementing coupon usage: $e');
    }
  }

  /// ---------------- FETCH ORDERS ----------------
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      return await orderRepository.fetchUserOrders();
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  /// ---------------- RAZORPAY ORDER ----------------
  void processOrder(double totalAmount) async {
    try {
      /// Validate address
      if (addressController.selectedAddress.value.id.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'No Address Selected',
          message: 'Please select a delivery address.',
        );
        return;
      }

      /// Validate cart
      if (cartController.cartItems.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'Cart is Empty',
          message: 'Add items before checkout.',
        );
        return;
      }

      TFullScreenLoader.openLoadingDialog(
          'Initializing payment...', TImages.pencilAnimation);

      final userId = authRepository.authUser?.uid;

      if (userId == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'User not logged in');
        return;
      }

      /// Create readable order ID (e.g., ORD-20241215-143025)
      final timestamp = DateTime.now();
      final orderId =
          'ORD-${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}-${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}';

      /// Calculate final amount with shipping and tax
      final subtotal = cartController.totalCartPrice.value;
      final shipping = _calculateShipping(subtotal);
      final tax = _calculateTax(subtotal);
      final discount = checkoutController.discountAmount.value;
      final finalAmount = subtotal + shipping + tax - discount;

      /// Store pending order
      _pendingOrder = OrderModel(
        id: orderId,
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: finalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Razorpay',
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 5)),
        items: cartController.cartItems.toList(),
        couponCode: checkoutController.couponCode.value,
        discountAmount: discount,
        subtotal: subtotal,
        shippingCost: shipping,
        taxAmount: tax,
      );

      isProcessingPayment.value = true;
      TFullScreenLoader.stopLoading();

      _openRazorpayCheckout(amount: finalAmount, userId: userId);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      isProcessingPayment.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// ---------------- OPEN RAZORPAY ----------------
  void _openRazorpayCheckout({
    required double amount,
    required String userId,
  }) {
    final user = authRepository.authUser;

    final options = {
      'key': 'rzp_test_xDH74d48cwl8DF',
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': 'I-Store',
      'description': 'Order Payment',
      'prefill': {
        'contact': user?.phoneNumber ?? '9999999999',
        'email': user?.email ?? 'test@test.com',
      },
      'theme': {'color': '#F9774E'},
    };

    try {
      print('💰 Opening Razorpay with amount: ₹$amount');
      _razorpay.open(options);
    } catch (e) {
      isProcessingPayment.value = false;
      TLoaders.errorSnackBar(
        title: 'Payment Error',
        message: e.toString(),
      );
    }
  }

  /// ---------------- SUCCESS ----------------
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      print('✅ Payment Successful: ${response.paymentId}');

      final userId = authRepository.authUser?.uid;
      if (userId == null || _pendingOrder == null) return;

      // ✅ Increment coupon usage BEFORE saving order
      await _incrementCouponUsage();

      TFullScreenLoader.openLoadingDialog(
          'Saving order...', TImages.pencilAnimation);

      final finalOrder = _pendingOrder!.copyWith(
        status: OrderStatus.confirmed,
        paymentId: response.paymentId,
        paymentStatus: 'paid',
      );

      await orderRepository.saveOrder(finalOrder, userId);

      cartController.clearCart();
      checkoutController.removeCoupon();

      TFullScreenLoader.stopLoading();

      Get.offAll(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Payment Successful!',
            subTitle: 'Your order has been placed successfully.',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error Saving Order',
        message: e.toString(),
      );
    }
  }

  /// ---------------- ERROR ----------------
  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment Failed: ${response.message}');
    isProcessingPayment.value = false;

    TLoaders.errorSnackBar(
      title: 'Payment Failed',
      message: response.message ??
          'Please try again with a different payment method.',
    );
  }

  /// ---------------- WALLET ----------------
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('💰 External Wallet Selected: ${response.walletName}');
    isProcessingPayment.value = false;
  }

  /// ---------------- COD ----------------
  void processCODOrder(double totalAmount) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Placing order...', TImages.pencilAnimation);

      final userId = authRepository.authUser?.uid;
      if (userId == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'User not logged in');
        return;
      }

      // ✅ Increment coupon usage BEFORE saving order
      await _incrementCouponUsage();

      final timestamp = DateTime.now();
      final orderId =
          'ORD-${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}-${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}${timestamp.second.toString().padLeft(2, '0')}';

      final subtotal = cartController.totalCartPrice.value;
      final shipping = _calculateShipping(subtotal);
      final tax = _calculateTax(subtotal);
      final discount = checkoutController.discountAmount.value;
      final finalAmount = subtotal + shipping + tax - discount;

      final order = OrderModel(
        id: orderId,
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: finalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Cash on Delivery',
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 5)),
        items: cartController.cartItems.toList(),
        couponCode: checkoutController.couponCode.value,
        discountAmount: discount,
        subtotal: subtotal,
        shippingCost: shipping,
        taxAmount: tax,
      );

      await orderRepository.saveOrder(order, userId);

      cartController.clearCart();
      checkoutController.removeCoupon();

      TFullScreenLoader.stopLoading();

      Get.offAll(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Order Placed!',
            subTitle:
                'Cash on Delivery selected. Our team will contact you shortly.',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
