import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Get all brands
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      return snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching Brands.';
    }
  }

  /// Get Brands For Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['brandId'] as String)
          .toList();

      final brandsQuery = await _db
          .collection('Brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(2)
          .get();

      List<BrandModel> brands =
          brandsQuery.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();

      return brands;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching Brands.';
    }
  }

  /// Upload or replace a single brand with image to Firebase Storage
  Future<void> uploadOrReplaceBrand(BrandModel brand) async {
    try {
      ByteData byteData = await rootBundle.load(brand.image);
      Uint8List imageData = byteData.buffer.asUint8List();

      final ref = _storage.ref().child('brands/${brand.id}.png');
      await ref.putData(imageData);
      final downloadUrl = await ref.getDownloadURL();

      brand.image = downloadUrl;

      await _db.collection('Brands').doc(brand.id).set(brand.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Error uploading brand: $e';
    }
  }

  /// Upload all brands — Only add NEW ones, never delete existing
  Future<void> uploadAllBrands(List<BrandModel> brands) async {
    try {
      // Fetch all existing brand IDs from Firestore
      final snapshot = await _db.collection('Brands').get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

      for (var brand in brands) {
        // Skip if this brand already exists
        if (existingIds.contains(brand.id)) {
          print('Skipping existing brand: ${brand.name}');
          continue;
        }

        // New brand — upload it
        await uploadOrReplaceBrand(brand);
        print('Added new brand: ${brand.name}');
      }

      print('Brand sync complete. Only new brands were added.');
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Error syncing brands: $e';
    }
  }
}