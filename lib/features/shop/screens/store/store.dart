import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/appbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/appbar/tabbar.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/brands/brand_card.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/layouts/grid_layout.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/brand_shimmer.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/texts/section_heading.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/category_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/brands/all_brands.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/brands/brand_products.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/cart/cart.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/store/widget/category_tab.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:yt_ecommerce_admin_panel/utils/helpers/helper_functions.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TAppBar(
          title:
              Text("Store", style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            TCartCounterIcon(),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ///   Search Bar
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TSearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      ///   Featured Brands
                      TSectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                      Obx(
                        () {
                          if (brandController.isLoading.value) {
                            return const TBrandShimmer();
                          }
                          if (brandController.featuredBrands.isEmpty) {
                            return Center(
                              child: Text(
                                'No Data Found!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(color: Colors.white),
                              ),
                            );
                          }

                          return TGridLayout(
                              mainAxisExtent: 80,
                              itemCount: brandController.featuredBrands.length,
                              itemBuilder: (_, index) {
                                final brand =
                                    brandController.featuredBrands[index];
                                return TBrandCard(
                                  showBorder: true,
                                  brand: brand,
                                  onTap: () =>
                                      Get.to(() => BrandProducts(brand: brand)),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
                bottom: TTabBar(
                  tabs: categories
                      .map((category) => Tab(child: Text(category.name)))
                      .toList(),
                ),
              ),
            ];
          },
          body: TabBarView(
              children: categories
                  .map((category) => TCategoryTab(
                        category: category,
                        product: product,
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
