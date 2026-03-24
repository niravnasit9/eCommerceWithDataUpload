import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/login.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/signup/signup.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/signup/verify_email.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/address/address.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/profile/profile.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/screens/settings/settings.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/cart/cart.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/checkout/checkout.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/home/home.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/order/order.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/store/store.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/wishlist/wishlist.dart';
import 'package:yt_ecommerce_admin_panel/routes/routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    GetPage(name: TRoutes.store, page: () =>  StoreScreen(product: ProductModel.empty(),)),
    GetPage(name: TRoutes.favourites, page: () => FavouriteScreen(product: ProductModel.empty(),)),
    GetPage(name: TRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: TRoutes.productReviews, page: () => const ProductReviewsScreen()),
    GetPage(name: TRoutes.order, page: () => const OrderScreen()),
    GetPage(name: TRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: TRoutes.cart, page: () => const CartScreen()),
    GetPage(name: TRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: TRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: TRoutes.signup, page: () => const SignUpScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: TRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
    // Add more GetPage entries as needed
  ];
}
