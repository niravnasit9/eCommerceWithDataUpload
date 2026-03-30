import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// 🔥 CLOUDINARY CONFIG
  final String cloudName = "dtnfznfid";
  final String uploadPreset = "flutter_upload"; // EXACT SAME
  
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

      return brandsQuery.docs
          .map((doc) => BrandModel.fromSnapshot(doc))
          .toList();
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

  /// 🔥 Upload image to Cloudinary
  Future<String> uploadToCloudinary(String assetPath) async {
    try {
      print("📦 Loading image: $assetPath");

      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List imageData = byteData.buffer.asUint8List();

      final uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", uri);

      request.fields['upload_preset'] = uploadPreset;
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageData,
        filename: "brand.png",
      ));

      print("☁️ Uploading to Cloudinary...");

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        print("✅ Cloudinary Upload Success: ${data['secure_url']}");
        return data['secure_url'];
      } else {
        print("❌ Cloudinary Upload Failed");
        print("Status: ${response.statusCode}");
        print("Response: $resBody");
        throw "Cloudinary upload failed";
      }
    } catch (e) {
      print("❌ Cloudinary ERROR: $e");
      throw e;
    }
  }

  /// 🔥 Upload or Replace Brand (Cloudinary Based)
  Future<void> uploadOrReplaceBrand(BrandModel brand) async {
    try {
      print("🔵 START Upload Brand: ${brand.name}");

      /// Upload to Cloudinary
      final imageUrl = await uploadToCloudinary(brand.image);

      /// Replace local path with URL
      brand.image = imageUrl;

      /// Save to Firestore
      await _db.collection('Brands').doc(brand.id).set(brand.toJson());

      print("✅ Brand Uploaded: ${brand.name}");
    } on FirebaseException catch (e) {
      print("❌ FIREBASE ERROR");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print("❌ ERROR uploading brand ${brand.name}: $e");
      throw e.toString();
    }
  }

  /// 🔥 Upload ALL brands (NO SKIP, ALWAYS REPLACE)
  Future<void> uploadAllBrands(List<BrandModel> brands) async {
    try {
      print("🚀 START Uploading All Brands");

      for (var brand in brands) {
        print("➡️ Processing brand: ${brand.name}");

        try {
          await uploadOrReplaceBrand(brand);
        } catch (e) {
          print("❌ ERROR in brand: ${brand.name}");
          print("Error: $e");
        }
      }

      print("🎉 ALL BRANDS PROCESSED");
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Error uploading brands: $e';
    }
  }
}
