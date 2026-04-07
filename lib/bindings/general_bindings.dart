import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_banner_controller.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/banners/banner_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/brnads/brand_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/orders/order_repository.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/controllers/address_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/category_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/checkout_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/variation_controller.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(CategoryController());

    Get.put(AddressController());
    Get.put(CheckoutController());

    Get.put(BrandRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(BannerRepository(), permanent: true);
    Get.put(AdminBannerController(), permanent: true);
    Get.put(AdminBrandController(), permanent: true);
  }
}
