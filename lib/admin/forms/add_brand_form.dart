import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AddBrandForm extends StatefulWidget {
  const AddBrandForm({super.key, this.brand});

  final BrandModel? brand;

  @override
  State<AddBrandForm> createState() => _AddBrandFormState();
}

class _AddBrandFormState extends State<AddBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final productsCountController = TextEditingController();
  var isFeatured = false.obs;
  
  // Image handling
  File? _selectedImage;
  String? _existingImageUrl;
  bool _isUploading = false;
  
  final controller = Get.find<AdminBrandController>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.brand != null) {
      nameController.text = widget.brand!.name;
      productsCountController.text = widget.brand!.productsCount.toString();
      isFeatured.value = widget.brand!.isFeatured ?? false;
      _existingImageUrl = widget.brand!.image;
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Image Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Iconsax.camera,
                      label: 'Camera',
                      onTap: () => _getImage(ImageSource.camera),
                    ),
                    _buildImageSourceOption(
                      icon: Iconsax.gallery,
                      label: 'Gallery',
                      onTap: () => _getImage(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.md),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: dark ? TColors.darkerGrey : TColors.light,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: TColors.primary),
            const SizedBox(height: TSizes.sm),
            Text(label),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _existingImageUrl = null;
        });
      }
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _selectedImage = null;
      _existingImageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand == null ? 'Add Brand' : 'Edit Brand'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Brand Logo Image Picker
              const Text(
                'Brand Logo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              _buildImagePicker(),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Brand Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Brand Name',
                  prefixIcon: Icon(Iconsax.tag),
                  hintText: 'e.g., Apple, Samsung, Nike',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter brand name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Products Count
              TextFormField(
                controller: productsCountController,
                decoration: const InputDecoration(
                  labelText: 'Number of Products',
                  prefixIcon: Icon(Iconsax.box),
                  hintText: 'e.g., 50',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Featured Checkbox
              Obx(
                () => CheckboxListTile(
                  title: const Text('Featured Brand'),
                  subtitle: const Text('Show this brand in featured section'),
                  value: isFeatured.value,
                  onChanged: (value) {
                    isFeatured.value = value ?? false;
                  },
                  activeColor: TColors.primary,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isUploading || (_selectedImage == null && _existingImageUrl == null)) 
                      ? null 
                      : _saveBrand,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.brand == null ? 'Add Brand' : 'Update Brand',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildImagePicker() {
  final dark = THelperFunctions.isDarkMode(Get.context!);
  
  Widget content;
  
  if (_selectedImage != null) {
    content = Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Iconsax.trash, color: Colors.white, size: 18),
              onPressed: _removeImage,
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Iconsax.edit, color: Colors.white, size: 18),
              onPressed: _pickImage,
            ),
          ),
        ),
      ],
    );
  } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
    content = Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          child: Image.network(
            _existingImageUrl!,
            width: double.infinity,
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              color: dark ? TColors.darkerGrey : TColors.light,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.image, size: 50),
                  SizedBox(height: TSizes.sm),
                  Text('Image not found'),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Iconsax.trash, color: Colors.white, size: 18),
              onPressed: _removeImage,
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Iconsax.edit, color: Colors.white, size: 18),
              onPressed: _pickImage,
            ),
          ),
        ),
      ],
    );
  } else {
    content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Iconsax.gallery_add,
          size: 50,
          color: dark ? TColors.grey : TColors.darkGrey,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          'Tap to add brand logo',
          style: TextStyle(
            color: dark ? TColors.grey : TColors.darkGrey,
          ),
        ),
        const SizedBox(height: TSizes.xs),
        Text(
          'Supports JPG, PNG',
          style: TextStyle(
            fontSize: 12,
            color: dark ? TColors.grey : TColors.darkGrey,
          ),
        ),
      ],
    );
  }
  
  return GestureDetector(
    onTap: _pickImage,
    child: Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.light,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        border: Border.all(
          color: dark ? TColors.borderSecondary : TColors.borderPrimary,
          width: 1,
        ),
      ),
      child: content,
    ),
  );
}

  void _saveBrand() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _existingImageUrl == null) {
        Get.snackbar(
          'Error',
          'Please select a brand logo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.error,
          colorText: TColors.white,
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      String? uploadedImageUrl = _existingImageUrl;

      // Upload new image if selected
      if (_selectedImage != null) {
        uploadedImageUrl = await controller.uploadBrandImage(_selectedImage!);
        if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
          setState(() {
            _isUploading = false;
          });
          return;
        }
      }

      final brand = BrandModel(
        id: widget.brand?.id ?? '',
        name: nameController.text.trim(),
        image: uploadedImageUrl!,
        isFeatured: isFeatured.value,
        productsCount: int.tryParse(productsCountController.text) ?? 0,
      );

      if (widget.brand == null) {
        await controller.addBrand(brand);
      } else {
        await controller.updateBrand(brand);
      }
      
      setState(() {
        _isUploading = false;
      });
      
      Get.back();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    productsCountController.dispose();
    super.dispose();
  }
}