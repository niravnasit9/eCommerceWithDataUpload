import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_banner_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/brnads/brand_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/order_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/address_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/category_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/order_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/variation_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/image_controller.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Core Utilities
    Get.put(NetworkManager(), permanent: true);
    
    // Repositories - First
    Get.put(CouponRepository(), permanent: true);
    Get.put(BrandRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(BannerRepository(), permanent: true);
    
    // Image Controller (no dependencies)
    Get.put(ImagesController(), permanent: true);
    
    // Simple Controllers - Second
    Get.put(VariationController(), permanent: true);
    Get.put(CategoryController(), permanent: true);
    Get.put(AddressController(), permanent: true);
    
    // Complex Controllers (depend on repositories) - Third
    Get.put(CartController(), permanent: true);
    
    // Controllers that depend on CartController - Fourth
    Get.put(CheckoutController(), permanent: true);
    
    // ✅ Add OrderController
    Get.put(OrderController(), permanent: true);
    
    // Admin Controllers - Last
    Get.put(AdminBannerController(), permanent: true);
    Get.put(AdminBrandController(), permanent: true);
  }
}