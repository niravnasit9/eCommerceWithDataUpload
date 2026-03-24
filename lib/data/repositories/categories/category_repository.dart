import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/data/services/cloud_storage/firebase_storage_service.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/models/category_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final list = snapshot.docs
          .map((document) => CategoryModel.fromSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  /// Get sub Categories
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('Categories')
          .where('ParentId', isEqualTo: categoryId)
          .get();
      final result =
          snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  /// Upload Categories - Only add NEW ones, never delete existing
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try {
      // Fetch all existing category IDs from Firestore
      final snapshot = await _db.collection('Categories').get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

      final storage = Get.put(TFirebaseStorageService());

      for (var category in categories) {
        // Skip if this category already exists
        if (existingIds.contains(category.id)) {
          print('Skipping existing category: ${category.name}');
          continue;
        }

        // New category — upload image and save to Firestore
        final file = await storage.getImageDataFromAssets(category.image);
        final url =
            await storage.uploadImageData('Categories', file, category.name);
        category.image = url;

        await _db
            .collection('Categories')
            .doc(category.id)
            .set(category.toJson());
        print('Added new category: ${category.name}');
      }

      print('Category sync complete. Only new categories were added.');
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }
}