import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CloudinaryRepository extends GetxController {
  static CloudinaryRepository get instance => Get.find();

  /// 🔥 CLOUDINARY CONFIG
  final String cloudName = "dtnfznfid";
  final String uploadPreset = "flutter_upload";

  /// ✅ Upload user image to Cloudinary
  Future<String?> uploadUserImage(File image) async {
    try {
      print("📦 Uploading user image to Cloudinary: ${image.path}");
      
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'users/profiles';
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final imageUrl = data['secure_url'];
        print("✅ User image uploaded to Cloudinary: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: $resBody");
        throw "Upload failed with status: ${response.statusCode}";
      }
    } catch (e) {
      print("❌ Cloudinary upload error: $e");
      return null;
    }
  }

  /// ✅ Upload any image to Cloudinary (generic method)
  Future<String?> uploadImage(File image, String folder) async {
    try {
      print("📦 Uploading image to Cloudinary: ${image.path}");
      
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      
      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final imageUrl = data['secure_url'];
        print("✅ Image uploaded to Cloudinary: $imageUrl");
        return imageUrl;
      } else {
        print("❌ Upload failed: $resBody");
        return null;
      }
    } catch (e) {
      print("❌ Cloudinary upload error: $e");
      return null;
    }
  }

  /// ✅ Upload multiple images
  Future<List<String>> uploadMultipleImages(List<File> images, String folder) async {
    List<String> uploadedUrls = [];
    for (var image in images) {
      final url = await uploadImage(image, folder);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    return uploadedUrls;
  }
}