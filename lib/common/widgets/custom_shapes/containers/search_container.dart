import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/product_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/product_detail.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class TSearchContainer extends StatefulWidget {
  const TSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<TSearchContainer> createState() => _TSearchContainerState();
}

class _TSearchContainerState extends State<TSearchContainer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  final productRepository = Get.find<ProductRepository>();
  final productController = Get.find<ProductController>();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filtered = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _controller.addListener(_onChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _removeOverlay();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadAllProducts() async {
    try {
      final products = await productRepository.getAllProducts();
      _allProducts = products;
    } catch (_) {}
  }

  void _onChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      _removeOverlay();
      setState(() {});
      return;
    }

    _filtered = _allProducts
        .where((p) {
          return p.title.toLowerCase().contains(query) ||
              p.brand.name.toLowerCase().contains(query) ||
              p.categoryId.toLowerCase().contains(query);
        })
        .take(6)
        .toList();

    setState(() {});

    if (_filtered.isEmpty) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    final dark = THelperFunctions.isDarkMode(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (_) => Positioned(
        width: size.width - (TSizes.defaultSpace * 2),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(TSizes.defaultSpace, size.height + 4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            color: dark ? TColors.dark : Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _filtered.map((product) {
                  return InkWell(
                    onTap: () {
                      _controller.clear();
                      _removeOverlay();
                      _focusNode.unfocus();
                      Get.to(() => ProductDetail(product: product));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.md,
                        vertical: TSizes.sm,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(TSizes.sm),
                            child: Image.network(
                              product.thumbnail,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 44,
                                height: 44,
                                color: Colors.grey[200],
                                child: const Icon(Iconsax.image, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  product.brand.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            productController.getProductPrice(product),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: widget.padding,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          // ✅ Matches original: EdgeInsets.all(TSizes.md)
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: widget.showBackground
                ? dark
                    ? TColors.dark
                    : TColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: widget.showBorder ? Border.all(color: TColors.grey) : null,
          ),
          child: Row(
            children: [
              // ✅ Matches original: same icon + color logic
              Icon(
                widget.icon,
                color: dark ? TColors.darkerGrey : TColors.grey,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              // ✅ Replaces Text() with TextField — same visual weight
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: InputDecoration(
                    hintText: widget.text,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

              // Clear button — only shows while typing
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    _removeOverlay();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: dark ? TColors.darkerGrey : TColors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
