import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';

class CouponRepository extends GetxController {
  static CouponRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'Coupons';

  Future<List<CouponModel>> getAllCoupons() async {
    try {
      final snapshot = await _db.collection(collectionName).get();
      print('📦 getAllCoupons: Found ${snapshot.docs.length} coupons');
      return snapshot.docs.map((doc) => CouponModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('❌ getAllCoupons error: $e');
      throw 'Failed to fetch coupons: $e';
    }
  }

  /// Get active coupons - Modified to avoid composite index
  Future<List<CouponModel>> getActiveCoupons() async {
    try {
      print('🔍 getActiveCoupons: Checking for active coupons...');

      // First, check if any coupons exist at all
      final allDocs = await _db.collection(collectionName).get();
      print('📊 Total coupons in database: ${allDocs.docs.length}');

      if (allDocs.docs.isEmpty) {
        print('⚠️ No coupons found in database! Please upload coupons first.');
        return [];
      }

      // Get all active coupons
      final snapshot = await _db
          .collection(collectionName)
          .where('isActive', isEqualTo: true)
          .get();

      print('📊 Active coupons (isActive=true): ${snapshot.docs.length}');

      // Filter expired coupons in memory
      final now = Timestamp.now();
      final activeCoupons = snapshot.docs
          .where((doc) {
            final validTo = doc['validTo'] as Timestamp?;
            if (validTo == null) {
              print('⚠️ Coupon ${doc['code']} has no validTo date');
              return false;
            }
            final isValid = validTo.compareTo(now) > 0;
            if (!isValid) {
              print(
                  '⏭️ Coupon ${doc['code']} is expired (validTo: ${validTo.toDate()})');
            }
            return isValid;
          })
          .map((doc) => CouponModel.fromSnapshot(doc))
          .toList();

      print('✅ Active and valid coupons: ${activeCoupons.length}');
      for (var coupon in activeCoupons) {
        print(
            '   - ${coupon.code}: Min ₹${coupon.minimumOrderAmount}, ${coupon.discountText}');
      }

      return activeCoupons;
    } catch (e) {
      print('❌ getActiveCoupons error: $e');
      throw 'Failed to fetch active coupons: $e';
    }
  }

  /// Get valid coupons for users (active and not expired)
  Future<List<CouponModel>> getValidCoupons() async {
    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('isActive', isEqualTo: true)
          .get();

      final now = Timestamp.now();

      final validCoupons = snapshot.docs
          .where((doc) {
            final validTo = doc['validTo'] as Timestamp?;
            return validTo != null && validTo.compareTo(now) > 0;
          })
          .map((doc) => CouponModel.fromSnapshot(doc))
          .toList();

      // Sort by discount value (highest first)
      validCoupons.sort((a, b) => b.discountValue.compareTo(a.discountValue));

      return validCoupons;
    } catch (e) {
      print('Error fetching valid coupons: $e');
      return [];
    }
  }

  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('code', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return CouponModel.fromSnapshot(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch coupon: $e';
    }
  }

  Future<void> addCoupon(CouponModel coupon) async {
    try {
      await _db.collection(collectionName).doc(coupon.id).set(coupon.toJson());
      print('✅ Coupon added: ${coupon.code}');
    } catch (e) {
      print('❌ Failed to add coupon: $e');
      throw 'Failed to add coupon: $e';
    }
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      await _db
          .collection(collectionName)
          .doc(coupon.id)
          .update(coupon.toJson());
      print('✅ Coupon updated: ${coupon.code}');
    } catch (e) {
      print('❌ Failed to update coupon: $e');
      throw 'Failed to update coupon: $e';
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await _db.collection(collectionName).doc(couponId).delete();
      print('✅ Coupon deleted: $couponId');
    } catch (e) {
      print('❌ Failed to delete coupon: $e');
      throw 'Failed to delete coupon: $e';
    }
  }

  Future<void> incrementUsageCount(String couponId, String userId) async {
    try {
      print('📈 Incrementing usage for coupon: $couponId, user: $userId');

      // Get current coupon data
      final docRef = _db.collection(collectionName).doc(couponId);
      final doc = await docRef.get();

      if (!doc.exists) {
        print('❌ Coupon not found: $couponId');
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      final currentUsedCount = (data['usedCount'] ?? 0) as int;
      final currentUsedByUsers = List<String>.from(data['usedByUsers'] ?? []);
      final currentUsageDetails =
          Map<String, dynamic>.from(data['usageDetails'] ?? {});

      // Update lists
      final updatedUsedByUsers = [...currentUsedByUsers];
      if (!updatedUsedByUsers.contains(userId)) {
        updatedUsedByUsers.add(userId);
      }

      final updatedUsageDetails =
          Map<String, dynamic>.from(currentUsageDetails);
      updatedUsageDetails[userId] = Timestamp.now();

      // Update Firestore
      await docRef.update({
        'usedCount': currentUsedCount + 1,
        'usedByUsers': updatedUsedByUsers,
        'usageDetails': updatedUsageDetails,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print(
          '✅ Coupon usage updated: ${currentUsedCount + 1} total uses, ${updatedUsedByUsers.length} unique users');
    } catch (e) {
      print('❌ Error updating coupon usage: $e');
      throw 'Failed to update coupon usage: $e';
    }
  }

  Future<CouponModel?> getCouponById(String couponId) async {
    try {
      final doc = await _db.collection(collectionName).doc(couponId).get();
      if (doc.exists) {
        return CouponModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch coupon: $e';
    }
  }

  Future<CouponModel?> validateCoupon(String code, double orderAmount) async {
    final coupon = await getCouponByCode(code);
    if (coupon == null) return null;
    if (!coupon.isValid) return null;
    if (coupon.minimumOrderAmount != null &&
        orderAmount < coupon.minimumOrderAmount!) return null;
    return coupon;
  }
}
