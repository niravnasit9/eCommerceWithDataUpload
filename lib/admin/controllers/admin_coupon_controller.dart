import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/coupons/coupon_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class AdminCouponController extends GetxController {
  static AdminCouponController get instance => Get.find();

  final CouponRepository _couponRepository = CouponRepository.instance;

  final isLoading = false.obs;
  final RxList<CouponModel> allCoupons = <CouponModel>[].obs;
  final RxList<CouponModel> filteredCoupons = <CouponModel>[].obs;
  final searchQuery = ''.obs;

  final totalCoupons = 0.obs;
  final activeCoupons = 0.obs;
  final expiredCoupons = 0.obs;
  final totalUses = 0.obs;
  final uniqueUsers = 0.obs;
  final averageUsesPerCoupon = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading.value = true;
      allCoupons.value = await _couponRepository.getAllCoupons();
      filteredCoupons.value = allCoupons;

      _calculateStats();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch coupons: $e');
    }
  }
    Future<void> addCoupon(CouponModel coupon) async {
    try {
      await _couponRepository.addCoupon(coupon);
      await fetchCoupons();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Coupon added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to add coupon: $e');
    }
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      await _couponRepository.updateCoupon(coupon);
      await fetchCoupons();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Coupon updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to update coupon: $e');
    }
  }

  void _calculateStats() {
    totalCoupons.value = allCoupons.length;
    activeCoupons.value = allCoupons.where((c) => c.isActive && !c.isExpired).length;
    expiredCoupons.value = allCoupons.where((c) => c.isExpired).length;
    
    totalUses.value = allCoupons.fold(0, (sum, c) => sum + c.usedCount);
    
    final allUsers = allCoupons.expand((c) => c.usedByUsers).toSet();
    uniqueUsers.value = allUsers.length;
    
    averageUsesPerCoupon.value = totalCoupons.value > 0 
        ? totalUses.value / totalCoupons.value 
        : 0.0;
  }

  void searchCoupons(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCoupons.value = allCoupons;
    } else {
      filteredCoupons.value = allCoupons.where((coupon) {
        return coupon.code.toLowerCase().contains(query.toLowerCase()) ||
            coupon.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await _couponRepository.deleteCoupon(couponId);
      await fetchCoupons();
      TLoaders.successSnackBar(title: 'Success', message: 'Coupon deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete coupon: $e');
    }
  }

  Future<void> toggleCouponStatus(String couponId, bool isActive) async {
    try {
      final coupon = allCoupons.firstWhere((c) => c.id == couponId);
      final updatedCoupon = CouponModel(
        id: coupon.id,
        code: coupon.code,
        description: coupon.description,
        discountType: coupon.discountType,
        discountValue: coupon.discountValue,
        minimumOrderAmount: coupon.minimumOrderAmount,
        maximumDiscount: coupon.maximumDiscount,
        validFrom: coupon.validFrom,
        validTo: coupon.validTo,
        usageLimit: coupon.usageLimit,
        usedCount: coupon.usedCount,
        isActive: isActive,
        applicableProducts: coupon.applicableProducts,
        applicableCategories: coupon.applicableCategories,
        usedByUsers: coupon.usedByUsers,
        usageDetails: coupon.usageDetails,
        createdAt: coupon.createdAt,
        updatedAt: DateTime.now(),
      );
      await _couponRepository.updateCoupon(updatedCoupon);
      await fetchCoupons();
      TLoaders.successSnackBar(
        title: 'Success', 
        message: isActive ? 'Coupon activated' : 'Coupon deactivated',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update coupon status: $e');
    }
  }
}