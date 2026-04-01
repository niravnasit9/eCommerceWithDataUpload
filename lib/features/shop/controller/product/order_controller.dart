import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/success_screen/success_screen.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
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
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepsitory());

  late Razorpay _razorpay;
  final RxBool isProcessingPayment = false.obs;

  /// ✅ Store pending order
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

      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'User not logged in');
        return;
      }

      /// ✅ Create clean order ID
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      /// ✅ Store pending order
      _pendingOrder = OrderModel(
        id: orderId,
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Razorpay',
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 5)),
        items: cartController.cartItems.toList(),
      );

      isProcessingPayment.value = true;
      TFullScreenLoader.stopLoading();

      _openRazorpayCheckout(amount: totalAmount, userId: userId);
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
    final user = AuthenticationRepository.instance.authUser;

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
      print(options);
      print('Opening Razorpay...');
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

      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || _pendingOrder == null) return;

      TFullScreenLoader.openLoadingDialog(
          'Saving order...', TImages.pencilAnimation);

      /// ✅ Update same order
      final finalOrder = _pendingOrder!.copyWith(
        status: OrderStatus.confirmed,
        paymentId: response.paymentId,
        paymentStatus: 'paid',
      );

      await orderRepository.saveOrder(finalOrder, userId);

      cartController.clearCart();

      TFullScreenLoader.stopLoading();

      Get.offAll(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Payment Successful!',
            subTitle: 'Your order has been placed successfully.',
            onPressed: () =>
                Get.offAll(() => const NavigationMenu()),
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
      message: response.message ?? 'Try again.',
    );
  }

  /// ---------------- WALLET ----------------
  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Wallet: ${response.walletName}');
    isProcessingPayment.value = false;
  }

  /// ---------------- COD ----------------
  void processCODOrder(double totalAmount) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Placing order...', TImages.pencilAnimation);

      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null) return;

      final order = OrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Cash on Delivery',
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now().add(const Duration(days: 5)),
        items: cartController.cartItems.toList(),
      );

      await orderRepository.saveOrder(order, userId);

      cartController.clearCart();

      TFullScreenLoader.stopLoading();

      Get.offAll(() => SuccessScreen(
            image: TImages.orderCompletedAnimation,
            title: 'Order Placed!',
            subTitle: 'Cash on Delivery selected.',
            onPressed: () =>
                Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}