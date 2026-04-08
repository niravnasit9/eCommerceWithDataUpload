import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/personalization/models/user_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔥 CLOUDINARY CONFIG
  final String cloudName = "dtnfznfid";
  final String uploadPreset = "flutter_upload";

  /// Function to Save user data in Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// Function to Fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// Function to update user data in Firestore.
  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updateUser.id)
          .update(updateUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// update any field in specific User Collection.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// Function to remove user data from Firebase.
  Future<void> removeUserRecords(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// ✅ Upload file to Cloudinary (replaces Firebase Storage)
  Future<String> uploadToCloudinaryFile(File file, String folder) async {
    try {
      print("📦 Uploading user image to Cloudinary: ${file.path}");
      
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        print("✅ User image uploaded to Cloudinary: ${data['secure_url']}");
        return data['secure_url'];
      } else {
        print("❌ Upload failed: $resBody");
        throw "Upload failed";
      }
    } catch (e) {
      print("❌ Cloudinary upload error: $e");
      throw "Cloudinary upload error: $e";
    }
  }

  /// ✅ Upload user profile picture to Cloudinary
  Future<String> uploadUserProfilePicture(File image) async {
    try {
      final imageUrl = await uploadToCloudinaryFile(image, 'users/profiles');
      return imageUrl;
    } catch (e) {
      throw 'Failed to upload profile picture: $e';
    }
  }

  /// ✅ Upload any image (kept for backward compatibility)
  @Deprecated('Use uploadToCloudinaryFile instead')
  Future<String> uploadImage(String path, XFile image) async {
    try {
      // This method is deprecated - use Cloudinary instead
      // Keeping for backward compatibility
      final file = File(image.path);
      final imageUrl = await uploadToCloudinaryFile(file, 'users/images');
      return imageUrl;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }
}