import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yt_ecommerce_admin_panel/data/abstract/products.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// CHECK IF PRODUCTS ALREADY EXIST
  Future<bool> productsAlreadyUploaded() async {
    final snapshot = await _db.collection('Products').get();
    return snapshot.docs.isNotEmpty;
  }

  /// SMART SYNC — Only add NEW products, never delete existing ones
  Future<void> syncNewProductsOnly() async {
    try {
      // Fetch all existing product IDs from Firestore
      final snapshot = await _db.collection('Products').get();
      final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

      for (var product in dummyProducts) {
        // Skip if this product already exists
        if (existingIds.contains(product.id)) {
          print('Skipping existing product: ${product.title}');
          continue;
        }

        // New product — upload images to Firebase Storage
        List<String> uploadedImages = [];

        if (product.images != null) {
          for (var imgPath in product.images!) {
            final fileName = imgPath.split('/').last;
            final byteData = await rootBundle.load(imgPath);
            final bytes = byteData.buffer.asUint8List();

            final storageRef = _storage.ref().child('Products/$fileName');
            await storageRef.putData(bytes);
            final downloadUrl = await storageRef.getDownloadURL();
            uploadedImages.add(downloadUrl);
          }
        }

        product.images = uploadedImages;

        // Upload thumbnail
        if (!uploadedImages.contains(product.thumbnail)) {
          final byteData = await rootBundle.load(product.thumbnail);
          final bytes = byteData.buffer.asUint8List();
          final fileName = product.thumbnail.split('/').last;

          final storageRef = _storage.ref().child('Products/$fileName');
          await storageRef.putData(bytes);
          product.thumbnail = await storageRef.getDownloadURL();
        } else {
          product.thumbnail = uploadedImages.first;
        }

        // Save new product to Firestore
        await _db.collection('Products').doc(product.id).set(product.toJson());
        print('Added new product: ${product.title}');
      }

      print('Product sync complete. Only new products were added.');
    } catch (e) {
      throw 'Error syncing products: $e';
    }
  }

  /// UPLOAD PRODUCTS FROM ASSETS (first time / full upload)
  Future<void> uploadProductsFromAssets() async {
    try {
      for (var product in dummyProducts) {
        List<String> uploadedImages = [];

        if (product.images != null) {
          for (var imgPath in product.images!) {
            final fileName = imgPath.split('/').last;
            final byteData = await rootBundle.load(imgPath);
            final bytes = byteData.buffer.asUint8List();

            final storageRef = _storage.ref().child('Products/$fileName');
            await storageRef.putData(bytes);
            final downloadUrl = await storageRef.getDownloadURL();
            uploadedImages.add(downloadUrl);
          }
        }

        product.images = uploadedImages;

        if (!uploadedImages.contains(product.thumbnail)) {
          final byteData = await rootBundle.load(product.thumbnail);
          final bytes = byteData.buffer.asUint8List();
          final fileName = product.thumbnail.split('/').last;

          final storageRef = _storage.ref().child('Products/$fileName');
          await storageRef.putData(bytes);
          final downloadUrl = await storageRef.getDownloadURL();
          product.thumbnail = downloadUrl;
        } else {
          product.thumbnail = uploadedImages.first;
        }

        await _db.collection('Products').doc(product.id).set(product.toJson());
        print('Uploaded Product: ${product.title}');
      }

      print('All products uploaded successfully.');
    } catch (e) {
      throw 'Error uploading products: $e';
    }
  }

  /// DELETE ALL PRODUCTS
  Future<void> deleteAllProductsFromAssets() async {
    try {
      final snapshot = await _db.collection('Products').get();
      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data['Images'] != null) {
          for (String imageUrl in List<String>.from(data['Images'])) {
            try {
              await _storage.refFromURL(imageUrl).delete();
            } catch (_) {
              print('Image not found: $imageUrl');
            }
          }
        }

        if (data['Thumbnail'] != null) {
          try {
            await _storage.refFromURL(data['Thumbnail']).delete();
          } catch (_) {
            print('Thumbnail not found: ${data['Thumbnail']}');
          }
        }

        await doc.reference.delete();
      }

      print("All products deleted successfully.");
    } catch (e) {
      throw 'Error deleting products: $e';
    }
  }

  /// REPLACE PRODUCTS (DELETE + UPLOAD)
  Future<void> replaceProductsFromAssets() async {
    await deleteAllProductsFromAssets();
    await uploadProductsFromAssets();
  }

  /// EXISTING FETCH METHODS
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(500)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  Future<List<ProductModel>> getFavouriteProducts(
      List<String> productIds) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  Future<List<ProductModel>> getProductsForBrand(
      {required String brandName, int limit = -1}) async {
    try {
      final querySnapshot = limit == -1
          ? await _db
              .collection('Products')
              .where('Brand.Name', isEqualTo: brandName)
              .get()
          : await _db
              .collection('Products')
              .where('Brand.Name', isEqualTo: brandName)
              .limit(limit)
              .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  Future<List<ProductModel>> getProductsForCategory(
      {required String categoryId, int limit = 4}) async {
    try {
      QuerySnapshot productCategoryQuery = limit == -1
          ? await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .get()
          : await _db
              .collection('ProductCategory')
              .where('categoryId', isEqualTo: categoryId)
              .limit(limit)
              .get();

      List<String> productIds = productCategoryQuery.docs
          .map((doc) => doc['productId'] as String)
          .toList();

      final productsQuery = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      return productsQuery.docs
          .map((doc) => ProductModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}