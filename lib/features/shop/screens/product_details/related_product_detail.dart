import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/product_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/widgets/product_attributs.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class RelatedProductDetail extends StatefulWidget {
  const RelatedProductDetail({super.key, required this.product});

  final ProductModel product;

  @override
  State<RelatedProductDetail> createState() => _RelatedProductDetailState();
}

class _RelatedProductDetailState extends State<RelatedProductDetail> {
  late final ProductController productController;

  @override
  void initState() {
    super.initState();
    // Use product ID as unique tag so this controller is fully isolated
    productController = Get.put(
      ProductController(),
      tag: widget.product.id,
    );

    Future.delayed(Duration.zero, () {
      productController.fetchRelatedProducts(
        currentProductId: widget.product.id,
        categoryId: widget.product.categoryId,
        brandId: widget.product.brand.id,
      );
    });
  }

  @override
  void dispose() {
    // Clean up isolated controller when screen is popped
    Get.delete<ProductController>(tag: widget.product.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(product: widget.product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Image Slider
            TProductImageSlider(product: widget.product),

            /// Details
            Padding(
              padding: const EdgeInsets.only(
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TRatingAndShare(),
                  TProductMetaData(product: widget.product),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// ATTRIBUTES
                  if (widget.product.productAttributes != null &&
                      widget.product.productAttributes!.isNotEmpty) ...[
                    TProductAttributes(product: widget.product),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// VARIATIONS
                  if (widget.product.productVariations != null &&
                      widget.product.productVariations!.isNotEmpty) ...[
                    const TSectionHeading(
                        title: 'Available Variations', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Column(
                      children: widget.product.productVariations!.map((variation) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                variation.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image, size: 30),
                              ),
                            ),
                            title: Text(
                              "₹${variation.price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              variation.attributeValues.entries
                                  .map((e) => "${e.key}: ${e.value}")
                                  .join(" • "),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// SHORT DESCRIPTION
                  const TSectionHeading(
                      title: 'Description', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    widget.product.shortDescription.isNotEmpty
                        ? widget.product.shortDescription
                        : 'No description available',
                    trimLines: 2,
                    trimCollapsedText: ' Show More',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    lessStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// FULL DESCRIPTION
                  if (widget.product.fullDescription.isNotEmpty) ...[
                    const TSectionHeading(
                        title: 'Full Description', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      widget.product.fullDescription,
                      style: const TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// HIGHLIGHTS
                  if (widget.product.highlights.isNotEmpty) ...[
                    const TSectionHeading(
                        title: 'Highlights', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      padding: const EdgeInsets.all(TSizes.sm),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(TSizes.md),
                      ),
                      child: Column(
                        children: widget.product.highlights.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.circle, size: 6, color: Colors.green),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(e, style: const TextStyle(fontSize: 14)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// SPECIFICATIONS
                  if (widget.product.specifications.isNotEmpty) ...[
                    const TSectionHeading(
                        title: 'Specifications', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Container(
                      padding: const EdgeInsets.all(TSizes.md),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(TSizes.md),
                      ),
                      child: Column(
                        children: widget.product.specifications.entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: TSizes.spaceBtwItems / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14)),
                                Text(e.value,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// DATE
                  if (widget.product.createdAt != null) ...[
                    Row(
                      children: [
                        const Icon(Iconsax.calendar, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Added on: ${widget.product.createdAt!.day}/${widget.product.createdAt!.month}/${widget.product.createdAt!.year}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],

                  /// RELATED PRODUCTS SECTION
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const TSectionHeading(
                    title: 'You Might Also Like',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Obx(() {
                    if (productController.isLoadingRelated.value) {
                      return SizedBox(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (_, __) => const SizedBox(
                            width: 180,
                            child: TVerticalProductShimmer(),
                          ),
                        ),
                      );
                    }

                    if (productController.relatedProducts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.md),
                          child: Column(
                            children: [
                              Icon(Iconsax.shop, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: TSizes.sm),
                              Text(
                                'No related products found',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productController.relatedProducts.length,
                        itemBuilder: (_, index) {
                          final relatedProduct =
                              productController.relatedProducts[index];
                          return Container(
                            width: 180,
                            margin: const EdgeInsets.only(right: TSizes.sm),
                            child: GestureDetector(
                              onTap: () {
                                // Navigates to another RelatedProductDetail,
                                // each with its own isolated controller tag
                                Get.to(() => RelatedProductDetail(
                                      product: relatedProduct,
                                    ));
                              },
                              child: TProductCardVertical(product: relatedProduct),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// REVIEWS
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(
                          title: 'Reviews', showActionButton: false),
                      IconButton(
                        onPressed: () =>
                            Get.to(() => const ProductReviewsScreen()),
                        icon: const Icon(Iconsax.arrow_right_3),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}