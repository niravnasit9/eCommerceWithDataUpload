import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_product_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key, this.product});

  final ProductModel? product;

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AdminProductController());

  // Basic Info Controllers
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final salePriceController = TextEditingController();
  final stockController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final fullDescriptionController = TextEditingController();

  // Highlights & Specifications
  final List<String> highlights = [];
  final Map<String, String> specifications = {};
  final TextEditingController highlightController = TextEditingController();
  final TextEditingController specKeyController = TextEditingController();
  final TextEditingController specValueController = TextEditingController();

  // Images
  final List<File> selectedImages = [];
  final List<String> existingImageUrls = [];
  File? thumbnailImage;
  String? existingThumbnailUrl;
  bool _isUploading = false;

  // Attributes & Variations
  final List<ProductAttributeModel> attributes = [];
  final List<ProductVariationModel> variations = [];

  BrandModel? selectedBrand;
  bool isFeatured = false;
  bool isEditing = false;

  // Suggestions data
  final List<String> productTitleSuggestions = [
    'iPhone 15 Pro Max', 'Samsung Galaxy S24 Ultra', 'OnePlus 12', 
    'Google Pixel 8 Pro', 'Xiaomi 14 Pro', 'Realme 12 Pro+',
    'Nothing Phone 2', 'Vivo X100 Pro', 'Motorola Edge 40'
  ];
  
  final List<String> highlightSuggestions = [
    'Snapdragon 8 Gen 3 Processor',
    '120Hz AMOLED Display',
    '100W Fast Charging',
    '5000mAh Battery',
    '200MP Camera',
    'IP68 Water Resistance',
    'Wireless Charging',
    '5G Support',
    'In-display Fingerprint',
    'Stereo Speakers',
  ];
  
  final Map<String, List<String>> specSuggestions = {
    'Display': ['6.7 inch AMOLED', '6.1 inch OLED', '6.8 inch Dynamic AMOLED', '6.5 inch LCD', '6.9 inch LTPO AMOLED'],
    'Processor': ['Snapdragon 8 Gen 3', 'A17 Pro', 'Dimensity 9300', 'Exynos 2400', 'Tensor G3'],
    'RAM': ['8GB', '12GB', '16GB', '24GB', '6GB'],
    'Storage': ['128GB', '256GB', '512GB', '1TB', '64GB'],
    'Camera': ['50MP + 12MP + 8MP', '108MP + 8MP + 2MP', '200MP + 12MP + 10MP', '48MP + 12MP'],
    'Front Camera': ['32MP', '16MP', '12MP', '48MP', '8MP'],
    'Battery': ['5000mAh', '4500mAh', '6000mAh', '4000mAh', '5500mAh'],
    'Operating System': ['Android 14', 'iOS 17', 'Android 13'],
    'Charging': ['67W Fast Charging', '100W Fast Charging', '120W HyperCharge', '45W Fast Charging'],
  };

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    isEditing = widget.product != null;
    
    if (isEditing) {
      _loadProductData();
    }
    
    controller.fetchBrands();
    
    if (isEditing && widget.product != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final matchingBrand = controller.brands.firstWhere(
          (b) => b.id == widget.product!.brand.id,
          orElse: () => widget.product!.brand,
        );
        if (matchingBrand.id.isNotEmpty) {
          setState(() {
            selectedBrand = matchingBrand;
          });
        }
      });
    }
  }

  void _loadProductData() {
    final product = widget.product!;
    
    titleController.text = product.title;
    priceController.text = product.price.toString();
    salePriceController.text = product.salePrice.toString();
    stockController.text = product.stock.toString();
    shortDescriptionController.text = product.shortDescription;
    fullDescriptionController.text = product.fullDescription;
    
    highlights.addAll(product.highlights);
    specifications.addAll(product.specifications);
    selectedBrand = product.brand;
    isFeatured = product.isFeatured;
    existingImageUrls.addAll(product.images ?? []);
    existingThumbnailUrl = product.thumbnail;
    
    if (product.productAttributes != null) {
      attributes.addAll(product.productAttributes!);
    }
    
    if (product.productVariations != null) {
      variations.addAll(product.productVariations!);
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        for (var image in images) {
          selectedImages.add(File(image.path));
        }
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        thumbnailImage = File(image.path);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      existingImageUrls.removeAt(index);
    });
  }

  void _removeThumbnail() {
    setState(() {
      thumbnailImage = null;
      existingThumbnailUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left),
        ),
        actions: [
          IconButton(
            onPressed: _saveProduct,
            icon: const Icon(Iconsax.save_2),
            tooltip: 'Save Product',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Product Title
              _buildTextFieldWithSuggestions(
                controller: titleController,
                label: 'Product Title',
                icon: Iconsax.tag,
                suggestions: productTitleSuggestions,
                validator: (v) => v?.isEmpty == true ? 'Enter product title' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Price Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: priceController,
                      label: 'Price (₹)',
                      icon: Iconsax.money,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., 49999',
                      validator: (v) => v?.isEmpty == true ? 'Enter price' : null,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: _buildTextField(
                      controller: salePriceController,
                      label: 'Sale Price (₹)',
                      icon: Iconsax.discount_circle,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., 44999 (optional)',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Stock & Brand Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: stockController,
                      label: 'Stock Quantity',
                      icon: Iconsax.box,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., 50',
                      validator: (v) => v?.isEmpty == true ? 'Enter stock' : null,
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(() {
                      if (controller.brands.isEmpty) {
                        return const SizedBox(
                          height: 56,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      return DropdownButtonFormField<String>(
                        value: selectedBrand?.id,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Brand',
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                        hint: const Text('Select Brand'),
                        items: controller.brands.map((brand) {
                          return DropdownMenuItem(
                            value: brand.id,
                            child: Text(
                              brand.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final brand = controller.brands.firstWhere(
                              (b) => b.id == value,
                              orElse: () => BrandModel.empty(),
                            );
                            setState(() => selectedBrand = brand);
                          }
                        },
                        validator: (v) => v == null ? 'Select brand' : null,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Featured Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isFeatured,
                    onChanged: (v) => setState(() => isFeatured = v ?? false),
                  ),
                  const Text('Featured Product'),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Product Images Section
              _buildSectionTitle('Product Images', action: 'Add Images', onAction: _pickImages),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildImagesGrid(),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              /// Thumbnail Section
              _buildSectionTitle('Thumbnail Image'),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildThumbnailPicker(),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Descriptions
              _buildSectionTitle('Descriptions'),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildTextField(
                controller: shortDescriptionController,
                label: 'Short Description',
                icon: Iconsax.text,
                maxLines: 2,
                hintText: 'Brief product description (shown in product cards)',
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildTextField(
                controller: fullDescriptionController,
                label: 'Full Description',
                icon: Iconsax.document_text,
                maxLines: 5,
                hintText: 'Detailed product description with features and benefits',
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Highlights
              _buildSectionTitle('Highlights', action: 'Add Highlight', onAction: _showAddHighlightDialog),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildHighlightsList(),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Specifications
              _buildSectionTitle('Specifications', action: 'Add Specification', onAction: _showAddSpecificationDialog),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildSpecificationsList(),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Attributes
              _buildSectionTitle('Product Attributes', action: 'Add Attribute', onAction: _showAddAttributeDialog),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildAttributesList(),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Variations
              _buildSectionTitle('Product Variations', action: 'Generate Variations', onAction: _generateVariations),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildVariationsList(),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    ),
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
                          isEditing ? 'Update Product' : 'Create Product',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (action != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Iconsax.add, size: 16),
            label: Text(action),
            style: TextButton.styleFrom(
              foregroundColor: TColors.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildTextFieldWithSuggestions({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> suggestions,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            hintText: 'e.g., iPhone 15 Pro Max',
          ),
          maxLines: maxLines,
          validator: validator,
          onFieldSubmitted: (value) => onFieldSubmitted(),
        );
      },
    );
  }

  Widget _buildImagesGrid() {
    THelperFunctions.isDarkMode(Get.context!);
    
    if (isEditing && existingImageUrls.isNotEmpty && selectedImages.isEmpty) {
      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: TSizes.spaceBtwItems,
              mainAxisSpacing: TSizes.spaceBtwItems,
            ),
            itemCount: existingImageUrls.length,
            itemBuilder: (_, index) => _buildExistingImageCard(index),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildAddMoreImagesButton(),
        ],
      );
    }
    
    if (selectedImages.isEmpty) {
      return _buildImagePickerCard();
    }
    
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: TSizes.spaceBtwItems,
            mainAxisSpacing: TSizes.spaceBtwItems,
          ),
          itemCount: selectedImages.length,
          itemBuilder: (_, index) => _buildImageCard(index),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildAddMoreImagesButton(),
      ],
    );
  }

  Widget _buildImagePickerCard() {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: dark ? TColors.darkerGrey : TColors.light,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(
            color: dark ? TColors.borderSecondary : TColors.borderPrimary,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.gallery_add,
              size: 40,
              color: dark ? TColors.grey : TColors.darkGrey,
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              'Tap to add images',
              style: TextStyle(
                color: dark ? TColors.grey : TColors.darkGrey,
              ),
            ),
            const SizedBox(height: TSizes.xs),
            Text(
              'You can select multiple',
              style: TextStyle(
                fontSize: 12,
                color: dark ? TColors.grey : TColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoreImagesButton() {
    THelperFunctions.isDarkMode(Get.context!);
    
    return OutlinedButton.icon(
      onPressed: _pickImages,
      icon: const Icon(Iconsax.add, size: 16),
      label: const Text('Add More Images'),
      style: OutlinedButton.styleFrom(
        foregroundColor: TColors.primary,
        side: const BorderSide(color: TColors.primary),
        padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      ),
    );
  }

  Widget _buildImageCard(int index) {
    THelperFunctions.isDarkMode(Get.context!);
    
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Image.file(
            selectedImages[index], 
            fit: BoxFit.cover, 
            width: double.infinity, 
            height: double.infinity,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Iconsax.trash, size: 14, color: Colors.white),
              onPressed: () => _removeImage(index),
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              '${index + 1}/${selectedImages.length}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExistingImageCard(int index) {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Image.network(
            existingImageUrls[index],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              color: dark ? TColors.darkerGrey : TColors.light,
              child: const Icon(Iconsax.image, size: 30),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Iconsax.trash, size: 14, color: Colors.white),
              onPressed: () => _removeExistingImage(index),
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              '${index + 1}/${existingImageUrls.length}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailPicker() {
    final dark = THelperFunctions.isDarkMode(Get.context!);
    
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        border: Border.all(
          color: dark ? TColors.borderSecondary : TColors.borderPrimary,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: dark ? TColors.darkerGrey : TColors.light,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
              border: Border.all(
                color: dark ? TColors.borderSecondary : TColors.borderPrimary,
                width: 0.5,
              ),
            ),
            child: thumbnailImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    child: Image.file(thumbnailImage!, fit: BoxFit.cover),
                  )
                : (existingThumbnailUrl != null && existingThumbnailUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                        child: Image.network(existingThumbnailUrl!, fit: BoxFit.cover),
                      )
                    : Icon(Iconsax.image, size: 30, color: dark ? TColors.grey : TColors.darkGrey)),
          ),
          const SizedBox(width: TSizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Thumbnail',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: TSizes.xs),
                Text(
                  thumbnailImage != null 
                      ? 'New thumbnail selected' 
                      : (existingThumbnailUrl != null && existingThumbnailUrl!.isNotEmpty
                          ? 'Current thumbnail saved'
                          : 'No thumbnail selected'),
                  style: TextStyle(
                    fontSize: 12,
                    color: (thumbnailImage != null || (existingThumbnailUrl != null && existingThumbnailUrl!.isNotEmpty))
                        ? TColors.success 
                        : (dark ? TColors.grey : TColors.darkGrey),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (thumbnailImage != null || (existingThumbnailUrl != null && existingThumbnailUrl!.isNotEmpty))
                IconButton(
                  onPressed: _removeThumbnail,
                  icon: Icon(Iconsax.trash, color: TColors.error),
                  tooltip: 'Remove',
                ),
              ElevatedButton.icon(
                onPressed: _pickThumbnail,
                icon: const Icon(Iconsax.camera, size: 16),
                label: Text(thumbnailImage != null ? 'Change' : 'Select'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.xs),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsList() {
    return Column(
      children: [
        if (highlights.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: highlights.length,
            itemBuilder: (_, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: TSizes.sm),
                child: ListTile(
                  leading: const Icon(Iconsax.tick_circle, color: TColors.success),
                  title: Text(highlights[index]),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                    onPressed: () => setState(() => highlights.removeAt(index)),
                  ),
                ),
              );
            },
          ),
        if (highlights.isEmpty)
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            ),
            child: Column(
              children: [
                const Center(child: Text('No highlights added')),
                const SizedBox(height: TSizes.sm),
                Wrap(
                  spacing: TSizes.sm,
                  runSpacing: TSizes.sm,
                  children: highlightSuggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        setState(() => highlights.add(suggestion));
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpecificationsList() {
    return Column(
      children: [
        if (specifications.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specifications.length,
            itemBuilder: (_, index) {
              final entry = specifications.entries.elementAt(index);
              return Card(
                margin: const EdgeInsets.only(bottom: TSizes.sm),
                child: ListTile(
                  leading: const Icon(Iconsax.info_circle, color: TColors.primary),
                  title: Text(entry.key),
                  subtitle: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.trash, color: Colors.red),
                    onPressed: () => setState(() => specifications.remove(entry.key)),
                  ),
                ),
              );
            },
          ),
        if (specifications.isEmpty)
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            ),
            child: Wrap(
              spacing: TSizes.sm,
              runSpacing: TSizes.sm,
              children: specSuggestions.keys.map((key) {
                return FilterChip(
                  label: Text(key),
                  onSelected: (_) => _quickAddSpecification(key),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _quickAddSpecification(String key) {
    TextEditingController valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add $key'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return specSuggestions[key] ?? [];
                    }
                    return (specSuggestions[key] ?? []).where((option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    valueController.text = selection;
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: valueController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Value',
                        hintText: 'e.g., ${(specSuggestions[key] ?? []).first}',
                      ),
                      onSubmitted: (value) => onFieldSubmitted(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (valueController.text.isNotEmpty) {
                setState(() => specifications[key] = valueController.text);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesList() {
    if (attributes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        ),
        child: const Center(
          child: Text('No attributes added. Add attributes like Color, Storage, RAM to generate variations.'),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attributes.length,
      itemBuilder: (_, index) {
        final attr = attributes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: TSizes.sm),
          child: ListTile(
            leading: const Icon(Iconsax.colorfilter),
            title: Text(attr.name ?? 'Attribute'),
            subtitle: Text('Values: ${attr.values?.join(", ")}'),
            trailing: IconButton(
              icon: const Icon(Iconsax.trash, color: Colors.red),
              onPressed: () => setState(() => attributes.removeAt(index)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVariationsList() {
    if (variations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        ),
        child: const Center(
          child: Text('No variations generated. Add attributes first.'),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variations.length,
      itemBuilder: (_, index) {
        final varItem = variations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: TSizes.sm),
          child: ExpansionTile(
            title: Text(varItem.attributeValues.values.join(' / ')),
            subtitle: Text('Price: ₹${varItem.price} | Stock: ${varItem.stock}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: varItem.price.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Iconsax.money),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        variations[index].price = double.tryParse(value) ?? 0;
                      },
                    ),
                    const SizedBox(height: TSizes.sm),
                    TextFormField(
                      initialValue: varItem.stock.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        prefixIcon: Icon(Iconsax.box),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        variations[index].stock = int.tryParse(value) ?? 0;
                      },
                    ),
                    const SizedBox(height: TSizes.sm),
                    TextFormField(
                      initialValue: varItem.sku,
                      decoration: const InputDecoration(
                        labelText: 'SKU',
                        prefixIcon: Icon(Iconsax.barcode),
                      ),
                      onChanged: (value) {
                        variations[index].sku = value;
                      },
                    ),
                    const SizedBox(height: TSizes.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Get.snackbar('Success', 'Variation updated', backgroundColor: TColors.success, colorText: Colors.white);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                        ),
                        child: const Text('Update Variation'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddHighlightDialog() {
    highlightController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Highlight'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select from suggestions or type your own:'),
                const SizedBox(height: TSizes.spaceBtwItems),
                Wrap(
                  spacing: TSizes.sm,
                  runSpacing: TSizes.sm,
                  children: highlightSuggestions.map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion),
                      onPressed: () {
                        setState(() => highlights.add(suggestion));
                        Get.back();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: highlightController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Highlight',
                    hintText: 'Enter your own highlight',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (highlightController.text.isNotEmpty) {
                setState(() => highlights.add(highlightController.text));
                highlightController.clear();
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddSpecificationDialog() {
    specKeyController.clear();
    specValueController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Specification'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select from common keys:'),
                const SizedBox(height: TSizes.spaceBtwItems),
                Wrap(
                  spacing: TSizes.sm,
                  runSpacing: TSizes.sm,
                  children: specSuggestions.keys.map((key) {
                    return FilterChip(
                      label: Text(key),
                      onSelected: (_) {
                        specKeyController.text = key;
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: specKeyController,
                  decoration: const InputDecoration(
                    labelText: 'Specification Key',
                    hintText: 'e.g., Display, Processor',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: specValueController,
                  decoration: const InputDecoration(
                    labelText: 'Specification Value',
                    hintText: 'e.g., 6.7 inch AMOLED',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (specKeyController.text.isNotEmpty && specValueController.text.isNotEmpty) {
                setState(() => specifications[specKeyController.text] = specValueController.text);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddAttributeDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController valuesController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Attribute'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Common attributes: Color, Storage, RAM, Size'),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Attribute Name',
                    hintText: 'e.g., Color, Storage, RAM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: valuesController,
                  decoration: const InputDecoration(
                    labelText: 'Values (comma separated)',
                    hintText: 'e.g., Black, White, Blue',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && valuesController.text.isNotEmpty) {
                final values = valuesController.text.split(',').map((v) => v.trim()).toList();
                setState(() {
                  attributes.add(ProductAttributeModel(
                    name: nameController.text,
                    values: values,
                  ));
                });
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _generateVariations() {
    if (attributes.isEmpty) {
      Get.snackbar('Error', 'Add attributes first', backgroundColor: TColors.error, colorText: Colors.white);
      return;
    }

    List<Map<String, String>> combinations = [];
    _generateCombinations(attributes, 0, {}, combinations);

    setState(() {
      variations.clear();
      for (var combo in combinations) {
        variations.add(ProductVariationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + combo.hashCode.toString(),
          attributeValues: combo,
          price: double.parse(priceController.text),
          salePrice: double.parse(salePriceController.text.isNotEmpty ? salePriceController.text : '0'),
          stock: int.parse(stockController.text),
          sku: '',
          image: '',
        ));
      }
    });

    Get.snackbar('Success', 'Generated ${variations.length} variations', backgroundColor: TColors.success, colorText: Colors.white);
  }

  void _generateCombinations(List<ProductAttributeModel> attrs, int index, Map<String, String> current, List<Map<String, String>> result) {
    if (index == attrs.length) {
      result.add(Map.from(current));
      return;
    }
    for (var value in attrs[index].values!) {
      current[attrs[index].name!] = value;
      _generateCombinations(attrs, index + 1, current, result);
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate() && selectedBrand != null) {
      setState(() => _isUploading = true);
      
      // Upload new images to Cloudinary
      List<String> uploadedImageUrls = [];
      for (var img in selectedImages) {
        final url = await controller.uploadImage(img, 'products/images');
        if (url.isNotEmpty) {
          uploadedImageUrls.add(url);
        }
      }

      // Combine existing and new images
      final List<String> allImageUrls = [...existingImageUrls, ...uploadedImageUrls];

      String thumbnail = existingThumbnailUrl ?? '';
      if (thumbnailImage != null) {
        thumbnail = await controller.uploadImage(thumbnailImage!, 'products/thumbnail');
      }

      final product = ProductModel(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        stock: int.parse(stockController.text),
        price: double.parse(priceController.text),
        salePrice: double.parse(salePriceController.text.isNotEmpty ? salePriceController.text : '0'),
        thumbnail: thumbnail,
        images: allImageUrls,
        productType: attributes.isNotEmpty ? ProductType.variable.toString() : ProductType.single.toString(),
        categoryId: 'cat_mobile',
        shortDescription: shortDescriptionController.text,
        fullDescription: fullDescriptionController.text,
        highlights: highlights,
        specifications: specifications,
        brand: selectedBrand!,
        productAttributes: attributes,
        productVariations: variations,
        isFeatured: isFeatured,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        await controller.updateProduct(product);
      } else {
        await controller.addProduct(product);
      }

      setState(() => _isUploading = false);
      Get.back();
      Get.snackbar('Success', isEditing ? 'Product updated' : 'Product added', backgroundColor: TColors.success, colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Please fill all required fields', backgroundColor: TColors.error, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    salePriceController.dispose();
    stockController.dispose();
    shortDescriptionController.dispose();
    fullDescriptionController.dispose();
    highlightController.dispose();
    specKeyController.dispose();
    specValueController.dispose();
    super.dispose();
  }
}