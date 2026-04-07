import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_banner_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/banner_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AddBannerForm extends StatefulWidget {
  const AddBannerForm({super.key, this.banner});

  final BannerModel? banner;

  @override
  State<AddBannerForm> createState() => _AddBannerFormState();
}

class _AddBannerFormState extends State<AddBannerForm> {
  final _formKey = GlobalKey<FormState>();
  final _targetScreenController = TextEditingController();
  final _titleController = TextEditingController();

  // Image handling
  File? _selectedImage;
  String? _existingImageUrl;
  bool _isUploading = false;
  var isActive = true.obs;

  final controller = Get.find<AdminBannerController>();
  final ImagePicker _picker = ImagePicker();

  // ✅ Target Screen Suggestions
  final List<String> _targetScreenSuggestions = [
    '/home',
    '/products',
    '/product-detail',
    '/cart',
    '/checkout',
    '/profile',
    '/orders',
    '/favourites',
    '/search',
    '/settings',
    '/categories',
    '/brands',
    '/offers',
    '/new-arrivals',
    '/trending',
    '/wishlist',
    '/account',
    '/address',
    '/payment',
    '/order-tracking',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _targetScreenController.text = widget.banner!.targetScreen;
      _titleController.text = widget.banner!.title;
      isActive.value = widget.banner!.active;
      _existingImageUrl = widget.banner!.imageUrl;
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
        title: Text(widget.banner == null ? 'Add Banner' : 'Edit Banner'),
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
              /// Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Banner Title',
                  prefixIcon: Icon(Iconsax.text),
                  hintText: 'Enter banner title',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Banner Image Picker
              const Text(
                'Banner Image',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),

              _buildImagePicker(),

              const SizedBox(height: TSizes.spaceBtwItems),

              /// Target Screen with Suggestions
              _buildTargetScreenField(),

              const SizedBox(height: TSizes.spaceBtwItems),

              /// Active Status
              Obx(
                () => CheckboxListTile(
                  title: const Text('Active Banner'),
                  subtitle: const Text('Show this banner on the home screen'),
                  value: isActive.value,
                  onChanged: (value) {
                    isActive.value = value ?? false;
                  },
                  activeColor: TColors.success,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isUploading ||
                          (_selectedImage == null && _existingImageUrl == null))
                      ? null
                      : _saveBanner,
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
                          widget.banner == null
                              ? 'Add Banner'
                              : 'Update Banner',
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

  /// ✅ Target Screen Field with Autocomplete Suggestions
  Widget _buildTargetScreenField() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return _targetScreenSuggestions;
        }
        return _targetScreenSuggestions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        _targetScreenController.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Sync the autocomplete controller with your controller
        if (textEditingController.text != _targetScreenController.text) {
          textEditingController.text = _targetScreenController.text;
        }
        textEditingController.addListener(() {
          if (_targetScreenController.text != textEditingController.text) {
            _targetScreenController.text = textEditingController.text;
          }
        });
        
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Target Screen',
            prefixIcon: Icon(Iconsax.link),
            hintText: 'e.g., /home, /products, /cart',
            helperText: 'Start typing to see suggestions',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter target screen';
            }
            return null;
          },
          onFieldSubmitted: (value) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: MediaQuery.of(context).size.width - 32,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    leading: const Icon(Iconsax.link, size: 16),
                    onTap: () => onSelected(option),
                    hoverColor: TColors.primary.withOpacity(0.1),
                  );
                },
              ),
            ),
          ),
        );
      },
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
              height: 200,
              fit: BoxFit.cover,
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
              height: 200,
              fit: BoxFit.cover,
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
            size: 60,
            color: dark ? TColors.grey : TColors.darkGrey,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            'Tap to add banner image',
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
        height: 200,
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

  void _saveBanner() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _existingImageUrl == null) {
        Get.snackbar(
          'Error',
          'Please select a banner image',
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

      if (_selectedImage != null) {
        uploadedImageUrl = await controller.uploadBannerImage(_selectedImage!);
        if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) {
          setState(() {
            _isUploading = false;
          });
          return;
        }
      }

      final banner = BannerModel(
        id: widget.banner?.id ?? '',
        imageUrl: uploadedImageUrl!,
        targetScreen: _targetScreenController.text.trim(),
        title: _titleController.text.trim(),
        active: isActive.value,
      );

      if (widget.banner == null) {
        await controller.addBanner(banner);
      } else {
        await controller.updateBanner(banner);
      }

      setState(() {
        _isUploading = false;
      });

      Get.back();
    }
  }

  @override
  void dispose() {
    _targetScreenController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}